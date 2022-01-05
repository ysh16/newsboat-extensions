#!/bin/sh
# kkzz2rss.sh
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

html=$(curl -s "https://kkzz.kr/")

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>kkzz.kr / 꽁짤.com</title>
<link>https://kkzz.kr/</link>
EOF

echo "$html" | grep 'class="gallery-name"' \
	| awk -v today="$(TZ='Asia/Seoul' date +%F)" '
			BEGIN {
				RS = "gallery-item-box"
				FS = "[\"<>]"
			}
			/\/?vid=[0-9]+/ {
				date = today
				for (i = 0; i < NF; i++) {
					if ($i ~ /href/ && $(i+2) ~ /title/) {
						link = $(i+1)
						title = $(i+3)
					}
					if ($i ~ /^[0-9]{4}-[0-9]{2}-[0-9]{2}$/)
						date = $i ""
				}
				print date, link, title
			}' \
	| while read -r date link title; do
		cat <<-EOF
		<item>
		<title>$title</title>
		<link>$link</link>
		<guid>$link</guid>
		<pubDate>$(date -u -d"$date" +'%a, %d %b %Y %H:%M:%S +0900')</pubDate>
		</item>
		EOF
done

cat <<EOF
</channel>
</rss>
EOF
