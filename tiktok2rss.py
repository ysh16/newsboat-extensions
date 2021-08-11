#!/usr/bin/python
# takes the desired username as first argument
import sys, requests, json
from lxml import html
from datetime import datetime

user = sys.argv[1]
url = 'https://www.tiktok.com/@' + user

headers = { 'User-Agent': 'Mozilla/5.0 (Windows NT 10.0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36' }

page = requests.get(url, headers)
tree = html.fromstring(page.text)
data_json = tree.xpath('//*[@id="__NEXT_DATA__"]/text()')[0]
data_dict = json.loads(data_json)

feed_description = feed_title = user + ' TikTok'
print("""<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0">
<channel>
<title>{0}</title>
<description>{1}</description>
<link>{2}</link>""".format(feed_title, feed_description, url))

for tiktok in data_dict['props']['pageProps']['items']:
    title = tiktok['desc']
    if not title:
        title = 'New video from ' + user
    guid = link = 'https://www.tiktok.com/@' + user + '/video/' + tiktok['id']
    date = datetime.fromtimestamp(tiktok['createTime']).isoformat()
    description = tiktok['music']['title'] + ' - ' + \
        tiktok['music']['authorName']
    print("""
    <item>
    <title>{0}</title>
    <link>{1}</link>
    <guid>{2}</guid>
    <pubDate>{3}</pubDate>
    <description>{4}</description>
    </item>""".format(title, link, guid, date, description))

print("""
</channel>
</rss>""")