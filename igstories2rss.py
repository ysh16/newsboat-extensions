#!/usr/bin/python
# igstories2rss.py
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

import instaloader
import sys
import argparse

p = argparse.ArgumentParser()
p.add_argument('profile')
p.add_argument('-u', action='store', metavar='USERNAME', required=True)
p.add_argument('-p', action='store', metavar='PASSWORD')
args = p.parse_args(sys.argv[1:])

L = instaloader.Instaloader()

if not args.p:
    L.load_session_from_file(args.u)
else:
    L.login(args.u, args.p)

profile = instaloader.Profile.from_username(L.context, args.profile)

feed_description = feed_title = args.profile + ' Story'
url = 'https://www.instagram.com/stories/' + args.profile
print("""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>{0}</title>
<description>{1}</description>
<link>{2}</link>""".format(feed_title, feed_description, url))

for story in L.get_stories([profile.userid]):
    for item in story.get_items():
        if item.is_video:
            link = item.video_url
            title = 'New video story from ' + args.profile
        else:
            link = item.url
            title = 'New story from ' + args.profile
        date = item.date.isoformat()
        print("""
        <item>
        <title>{0}</title>
        <link>{1}</link>
        <pubDate>{2}</pubDate>
        </item>""".format(title, link, date))

print("""
</channel>
</rss>""")
