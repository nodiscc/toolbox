#!/usr/bin/python
# -*- coding: utf-8 -*-
'''
#Description: get bookmarks tag from a netscape-style bookmarks.html export and post
#them to Facebook or Twitter. Can post only links matching a specific tag, at a defined interval. 
#Allows setting number of link to post.
#Requires python-bs4, fbcmd, twidge
'''


import os
from bs4 import BeautifulSoup
from subprocess import call
import time
from time import strftime
import sys
import re

try:
    scriptname = sys.argv[0]
    usertag = sys.argv[1]
    bookmarksfilename = sys.argv[2]
    sleeptime = float(sys.argv[3])
    maxcount = int(sys.argv[4])
    service = sys.argv[5]
except (IndexError, ValueError):
    print '''USAGE: %s TAG BOOKMARKS_FILE INTERVAL NUMBER_OF_LINKS SERVICE
        TAG:             post links tagged TAG
        BOOKMARKS_FILE:  /path/to/bookmarks.html
        INTERVAL:        time to wait between posts
        NUMBER_OF_LINKS: post only N link
        SERVICE:         the service to use (fb or twitter) ''' % scriptname
    exit(1)

#Get params from user input (deprecated)
#usertag = raw_input('What tag do you want to share? (music, video...): ')
#bookmarksfilename = raw_input('Enter the bookmarks.html filename you want to read: ')
#sleeptime = float(raw_input('Time to wait between each post? (in seconds): '))
#maxcount = int(raw_input('How many links do you want to post? '))

bookmarksfile = open(bookmarksfilename)
rawdata = bookmarksfile.read()
data = BeautifulSoup(rawdata)
links = data.find_all('a')
excludedtags = ['it', 'doc', 'linux', 'webdev'] #TODO: ability to specify ignored tags on command line

postedfilename = "posted-" + service + ".txt"
posted = open(postedfilename, "a")
posteditems = ""
count = 0
expectedtime = maxcount * sleeptime

print '[facebook auto poster] Posting links about %s... This will take %s seconds' % (usertag, expectedtime)
print ""

for item in links:
    try:
        if usertag in item.get('tags') and "\n" + item.get('href') in open(postedfilename).read():
			outitem = item.contents[0]
			print "%s has already been posted." % outitem
        elif usertag in item.get('tags') and any(nopost in item.get('tags') for nopost in excludedtags):
            outitem = item.contents[0]
            print "%s was excluded because of links tags." % outitem
        elif usertag in item.get('tags') and count < maxcount:
            outitem = item.contents[0]
            print '[%s] Posting %s ...' % (strftime("%H:%M:%S"), outitem)
            if service == 'fb':
                call(["fbcmd", "FEEDLINK", item.get('href')])
            elif service == 'twitter':
                longtweet = item.get('href') + " " + outitem.encode('ascii','ignore')
                tweet = longtweet[0:140]
                call(["twidge", "update", tweet])
                #TODO: if twidge's exit status is not 0, something went wrong, Output an error message
                #TODO: append item.tags as hashtags
            else:
                print "Error: SERVICE must be fb or twitter."
                sys.exit(1)
            count = count + 1
            posted.write(item.get('href') + "\n")
            posteditems = posteditems + "\n" + item.get('href')
            print '%s items posted! Waiting for %s seconds ...' % (count, sleeptime)
            time.sleep(int(sleeptime))
        else:
            pass
    except TypeError:
        print "%s has no tags" % item.contents[0]

print '''
These %s links have been posted:''' % count
print posteditems
