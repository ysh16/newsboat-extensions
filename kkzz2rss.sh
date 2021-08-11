#!/bin/sh

html=$(curl -s "https://kkzz.kr/")

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>kkzz.kr / 꽁짤.com</title>
<link>https://kkzz.kr/</link>
EOF

echo "$html" | grep 'class="gallery-list-head"' \
	| awk 'BEGIN { RS="gallery-item-box" }
		/\/?vid=[0-9]+/ { gsub(/\n/, ""); print }' \
	| while read -r line; do
		link=$(echo "$line" | awk '{
			gsub(/" title=".*$/, "")
			gsub(/^.*href="/, "")
			print; exit }')
		item_html=$(curl -s "$link")
		title=$(echo "$item_html" | awk '
			BEGIN { FS="\"" }
			/name="title"/ {
				print $(NF-1)
				exit
			}')
		description=$(echo "$item_html" | awk '
			BEGIN { print "<![CDATA[" }
			/<iframe/ {
				gsub(/^.*src="/, "")
				gsub(/".*$/, "")
				if ($0 ~ /gfycat\.com\/IFR\/[a-zA-Z]/)
					sub(/IFR\//, "")
				print "<video src=\"" $0 "\"></video>"
			}
			END { print "]]>" }')
		date=$(echo "$item_html" | awk '
			BEGIN { FS="\"" }
			/property="article:published_time"/ {
				print $(NF-1)
				exit
			}')
		cat <<-EOF
		<item>
		<title>$title</title>
		<link>$link</link>
		<guid>$link</guid>
		<pubDate>$(date -u -d"$date" +'%a, %d %b %Y %H:%M:%S +0900')</pubDate>
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