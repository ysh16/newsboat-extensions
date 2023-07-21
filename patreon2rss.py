#!/usr/bin/python
# patreon2rss.py
# Copyright (C) 2022  ysh <thinkingaboutshu@waifu.club>
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

import sys
import re
import requests
import json
from html import escape

name = sys.argv[1]

resp = requests.get('https://www.patreon.com/' + name)
campaign_id = re.search(r'/campaign/([0-9]+)', resp.text).group(1)

url = 'https://www.patreon.com/api/posts?filter[campaign_id]=' + campaign_id + "&sort=-published_at&json-api-version=1.0"
headers = {
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0',
    'referer': 'https://www.patreon.com/' + name + '/posts'}

resp = requests.get(url, headers=headers)
data = json.loads(resp.text)

feed_title = data['included'][0]['attributes']['vanity']
feed_description = data['included'][1]['attributes']['summary']

print("""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>{0}</title>
<description>{1}</description>
<link>https://www.patreon.com/{2}</link>"""
    .format(feed_title, feed_description, feed_title))

for post in data['data']:
    title = post['attributes']['title']
    link = 'https://www.patreon.com' + post['attributes']['patreon_url']
    date = post['attributes']['edited_at']
    description = post['attributes']['teaser_text']
    if description is None:
        description = ''

    print("""
    <item>
    <title>{0}</title>
    <link>{1}</link>
    <pubDate>{2}</pubDate>
    <description>{3}</description>
    </item>"""
        .format(escape(title), link, date, escape(description)))

print("""
</channel>
</rss>""")
