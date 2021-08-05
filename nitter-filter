#!/usr/bin/env -S awk -f
{
	gsub(/https?:\/\/nitter\.[a-z]+.[a-z]+\/pic\/media%2F/, "https://pbs.twimg.com/media/")
	if ($0 !~ /ext_tw_video_thumb|video\.twimg\.com/)
		gsub(/https?:\/\/nitter\.[a-z]+.[a-z]+\//, "https://twitter.com/")
	gsub(/https?:\/\/invidious\.[a-z]+.[a-z]+\//, "https://youtu.be/")
	print
}
