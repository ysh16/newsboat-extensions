#!/bin/sh
# takes the full link to the desired naver blog as first argument

n=1 # if set, stop after n articles

url="${1:-https://post.naver.com/my/series/detail.naver?seriesNo=463657&memberNo=38791383}"
html=$(curl -s "$url")
title=$(echo "$html" | awk -F'"' '/og:title/ { print $(NF-1) }')
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>$title</title>
<link>$url</link>
EOF

i=0
echo "$html" | awk -F'"' '
	/data-cid/ {
		volumeNo = $10
		sub(/_.*/, "", volumeNo)
		print volumeNo
	}' | while read -r volumeNo; do
		if [ -n "$n" ]; then
			 [ "$i" -ge "$n" ] && break
		fi
		i=$((i+1))
		link="https://m.post.naver.com/viewer/postView.naver?volumeNo=$volumeNo"
		html=$(curl -s "$link")
		title=$(echo "$html" | awk -F'"' '/og:title/ { print $(NF-1) }')
		date=$(TZ='Asia/Seoul' date -d"$(echo "$html" \
			| awk -F'"' '/nv:news:date/ { print $(NF-1) }')" +'%a, %d %b %Y %H:%M:%S %z')
		description=$(echo "$html" \
			| grep -e 'data-image-id' -e 'data-linktype="img"' \
			| awk '
				BEGIN {
					RS = "\""
					print "<![CDATA["
				}
				/^https?/ && /jpg|JPG|png|PNG|gif|GIF/ && !/static\.post/ {
					gsub(/?.*$/, "")
					print "<img src=\"" $0 "\"/>"
				}
				END { print "]]>" }')
		cat <<-EOF
		<item>
		<title>$title</title>
		<link>$link</link>
		<guid>$volumeNo</guid>
		<pubDate>$date</pubDate>
		<description>
		$description
		</description>
		</item>
		EOF
done

cat <<EOF
</channel>
</rss>
EOF
