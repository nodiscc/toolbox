#!/usr/bin/env python

"""
#Description: Get description for a github project url

#Copyright: (c) 2015-2016 xlyphon
#License: MIT (http://opensource.org/licenses/MIT)

"""

import os
import sys
import requests
import subprocess
import json
import time
from sys import argv

repo_url = sys.argv[1]
githubname = repo_url.split('/')[3] + "/" + repo_url.split('/')[4] #Get github's format for repos names (user/repo)
#print githubname
apiurl = "https://api.github.com/repos/" + githubname.replace("\n","") #Get API info for the repo
#print "Getting API data..."
apidata = requests.get(apiurl).json()
if apidata.get("description"):
    description = apidata.get("description").encode('ascii', 'ignore')
else:
    description = ""
line = ' * ' + repo_url + ' - ' + description
print line
time.sleep(3)