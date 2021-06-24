#!/usr/bin/env python3
'''
# Description: backup reddit.com subscriptions/multireddits to a text file
# Usage : backup-reddit-multis.py USERNAME PASSWORD CLIENT_ID CLIENT_SECRET
# Outputs plain text lists of subreddits + multireddit RSS feed
# Requirements: praw, ID and secret from https://old.reddit.com/prefs/apps/ > create application > personal script
'''

import praw
from pprint import pprint
import sys
from sys import argv

user_agent = "Multireddit parser 0.1"
user_name = sys.argv[1]
password = sys.argv[2]
client_id = sys.argv[3]
client_secret = sys.argv[4]
r = praw.Reddit(user_agent=user_agent, client_id=client_id, client_secret=client_secret, username=user_name)

print('####### MULTIS ########')
multis = r.redditor(user_name).multireddits()
for multi in multis:
    print(multi.name)

print("")

for multi in multis:
    combinedurl = 'https://www.reddit.com/r/'
    print('######' + multi.name + '######')
    subreddits = multi.subreddits
    for subreddit in subreddits:
        print(subreddit.display_name)
        combinedurl = combinedurl + subreddit.display_name + '+'
    print("")
    print("Combined URL: " + combinedurl )
    print("")
