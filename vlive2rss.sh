#!/bin/sh
# takes the full link to the desired channel as first argument

url="$1"
channelseq=$(echo "$url" | awk -F'.*vlive.tv/channel/|/' '
    function parsehex(V,OUT)
    {
        if(V ~ /^0x/)
            V=substr(V,3)
        for(N=1; N<=length(V); N++)
            OUT=(OUT*16) + H[substr(V, N, 1)]
        return(OUT)
    }
    BEGIN {
        for(N=0; N<16; N++) {
            H[sprintf("%x",N)]=N
            H[sprintf("%X",N)]=N
        }
    }
    {
        hex = $2; len = length(hex)
        hexswap = substr(hex, len/2 + 1 + len%2, len/2) \
            substr(hex, 1, len/2 + len%2)
        print (parsehex(hexswap) + 13) / 8191
    }')
json=$(curl -s "api.vfan.vlive.tv/vproxy/channelplus/getChannelVideoList?app_id=8c6cc7b45d2568fb668be6e05b6e5a3b&channelSeq=$channelseq&maxNumRows=2&pageNo=1")

title=$(echo "$json" | jq -r '.result.channelInfo.channelName')
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>$title VLIVE</title>
<link>$url</link>
EOF

echo "$json" | jq -r '.result.videoList[] | [.title, .videoSeq, .onAirStartAt] | @tsv' \
	| while read -r line; do
		title=$(echo "$line" | cut -f1)
		link='https://www.vlive.tv/video/'$(echo "$line" | cut -f2)
		date=$(TZ='Asia/Seoul' date -d"$(echo "$line" | cut -f3)" +'%a, %d %b %Y %H:%M:%S %z')
		cat <<-EOF
		<item>
		<title>$title</title>
		<link>$link</link>
		<guid>$link</guid>
		<pubDate>$date</pubDate>
		</item>
		EOF
done

cat <<EOF
</channel>
</rss>
EOF
