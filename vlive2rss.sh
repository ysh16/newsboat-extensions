#!/bin/sh
# vlive2rss.sh - Takes the full link to the desired channel as first argument.
# Copyright (C) 2021  ysh <thinkingaboutshu@waifu.club>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

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
