#!/usr/bin/python
# re-filter.py - Filter RSS articles matching RegEx patterns.
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

import argparse
import sys
import re
from xml.etree.ElementTree import ElementTree

p = argparse.ArgumentParser()
p.add_argument('pattern')
p.add_argument("-i", action='store_true', help="Ignore case distinctions.")
p.add_argument("-v", action='store_true', help="Ignore matching items.")
args = p.parse_args(sys.argv[1:])

flags = re.IGNORECASE if args.i else 0
regex = re.compile(args.pattern, flags)

tree = ElementTree()
tree.parse(sys.stdin)

for channel in tree.findall('channel'):
    for item in tree.findall('.//item'):
        title = item.find('title')
        description = item.find('description')
        if title is not None:
            match = bool(regex.search(title.text))
            if not match and description is not None:
                match = bool(regex.search(description.text))
            if match ^ (not args.v):
                channel.remove(item)

tree.write(sys.stdout, encoding='unicode')