newsboat-extensions
-------------------

Collection of Snownews extensions meant for use with newsboat.

So-called "execurl" scripts in this repository have `2rss` in their
name, while the names of "filter" scripts contain `-filter`. For
more information on how to use these scripts inside newsboat see its
documentation's "SCRIPTS AND FILTERS" section.

Combining extensions
--------------------

Because of the way newsboat executes extensions, they can be combined
simply as follows.

```
"exec:~/newsboat-extensions/tiktok2rss.py user-name | ~/newsboat-extensions/re-filter.py -i 'pattern'"
```
```
"filter:~/newsboat-extensions/nitter-filter.awk | ~/newsboat-extensions/re-filter.py -i 'pattern':https://nitter.net/user-name/rss"
```

Usage with [sfeed](https://codemadness.org/sfeed.html)
------------------------------------------------------

For example, overwrite the fetch function in the sfeedrc(5) as
follows:

```
# fetch(name, url, feedfile)
fetch() {
	case "$2" in
	exec:*)
		sh -c "${2#exec:}" 2>/dev/null ;;
	filter:*)
		fstr=${2#filter:}
		curl "${fstr#*:}" 2>/dev/null \
			| sh -c "${fstr%%:*}" ;;
	*)
		curl "$2" 2>/dev/null ;;
	esac
}
```

Licence
-------

[AGPLv3+](LICENSE).
