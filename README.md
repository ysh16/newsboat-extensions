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

Licence
-------

[AGPLv3+](LICENSE).
