#!/bin/sh
# optionally, the first argument specifies a location

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
