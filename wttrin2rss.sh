#!/bin/sh
# wttrin2rss.sh - The optional first argument specifies a location.
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

url="https://wttr.in/$1"
data=$(curl -s "$url?T")
title=$(echo "$data" | head -n 1)

cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
  <channel>
    <title>$title</title>
    <link>$url</link>
    <description>wttr.in — the right way to check the weather!</description>
    <item>
      <title>$title</title>
      <link>$url</link>
      <guid>$(echo "$data" | md5sum)</guid>
      <description>
        <![CDATA[<PRE>$(echo "$data" | tail -n +3)</PRE>]]>
      </description>
    </item>
  </channel>
</rss>
EOF
