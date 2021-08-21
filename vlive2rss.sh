#!/bin/sh
# vlive2rss.sh - Takes full URL to the desired channel's starboard as argument.
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
board=$(awk -v url="$url" 'BEGIN {
		sub(/^.*board\//, "", url)
		sub(/[^0-9].*$/, "", url)
		print url
	}')
json=$(curl -s "https://www.vlive.tv/globalv-web/vam-web/post/v1.0/board-$board/videoPosts?appId=8c6cc7b45d2568fb668be6e05b6e5a3b&fields=officialVideo,channel%7BchannelName" \
	-H "referer: $url")

title=$(echo "$json" | jq -r '.data[0].channel.channelName')
cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>$title VLIVE</title>
<link>$url</link>
EOF

echo "$json" | jq -r '.data[].officialVideo
		| [.title, .videoSeq, .onAirStartAt] | @tsv' \
	| while read -r line; do
		title=$(echo "$line" | cut -f1)
		link='https://www.vlive.tv/video/'$(echo "$line" | cut -f2)
		date=$(TZ='Asia/Seoul' \
			date -d"@$(echo "$line" | cut -f3 | sed 's/...$//')" \
			+'%a, %d %b %Y %H:%M:%S %z')
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
