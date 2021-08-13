#!/usr/bin/python
# bibliogram-filter.py - Redirects file links to their Instagram source.
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
