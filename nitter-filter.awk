#!/usr/bin/env -S awk -f
# nitter-filter.awk - Substitube Nitter URLs with Twitter ones.
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

{
	gsub(/https?:\/\/nitter\.[a-z]+.[a-z]+\/pic\/media%2F/, "https://pbs.twimg.com/media/")
	if ($0 !~ /ext_tw_video_thumb|video\.twimg\.com/)
		gsub(/https?:\/\/nitter\.[a-z]+.[a-z]+\//, "https://twitter.com/")
	gsub(/https?:\/\/invidious\.[a-z]+.[a-z]+\//, "https://youtu.be/")
	print
}
