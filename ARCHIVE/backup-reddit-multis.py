#!/usr/bin/env python3
'''
#Description: backup reddit.com subscriptions/multireddits to a text file
#Usage : backup-reddit-multis.py USERNAME PASSWORD
# Outputs plain text lists of subreddits + multireddit RSS feed
'''

import praw
from pprint import pprint
import sys
from sys import argv

user_agent = "Multireddit parser 0.1"
user_name = sys.argv[1]
password = sys.argv[2]
r = praw.Reddit(user_agent=user_agent)
r.login (user_name, password, disable_warning=True)

print('####### MULTIS ########')
multis = r.get_multireddits(user_name)
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
