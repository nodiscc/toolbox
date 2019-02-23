#!/usr/bin/python
#Description: Download media items from an rss feed using youtube-dl
import feedparser
import sys
import subprocess

url = sys.argv[1]
tag = sys.argv[2]
#number = 10000
request = "%s%s" % (url, tag)



feed = feedparser.parse(request)

for entry in feed['entries']:
	dl_link = entry.get('link', '')
	dl_command = "youtube-dl %s" % (dl_link)
	subprocess.call(dl_command, shell=True)
