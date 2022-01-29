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

def matches(item, tags, re):
    for t in tags:
        tag = item.find(t)
        if tag is not None:
            if bool(regex.search(tag.text)):
                return True
    return False

p = argparse.ArgumentParser()
p.add_argument('pattern')
p.add_argument("-i", action='store_true', help="Ignore case distinctions.")
p.add_argument("-v", action='store_true', help="Ignore matching items.")
p.add_argument("-t", action='store', nargs='*', help="Tags to match against.")
args = p.parse_args(sys.argv[1:])

flags = re.IGNORECASE if args.i else 0
regex = re.compile(args.pattern, flags)

if args.t is None:
    args.t = ['title', 'description']

tree = ElementTree()
tree.parse(sys.stdin)

for channel in tree.findall('channel'):
    for item in tree.findall('.//item'):
        match = matches(item, args.t, regex)
        if match ^ (not args.v):
            channel.remove(item)

tree.write(sys.stdout, encoding='unicode')
