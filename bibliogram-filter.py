#!/usr/bin/python
# filter for bibliogram feeds that redirects file links to the instagram source

import sys, re
from xml.sax.saxutils import unescape as xml_unescape, escape as xml_escape
from urllib.parse import unquote as url_unquote

proxy_re = r'https?://bibliogram\..*\/(image|video)proxy\?url='

for line in sys.stdin:
    fields = line.split('"')
    for field in fields:
        field, n = re.subn(proxy_re, '', field)
        if n > 0:
            print(xml_escape(url_unquote(xml_unescape(field))), end='')
        else:
            print(field , sep='', end='')
        if field != fields[-1]:
            print('"' , end='')
