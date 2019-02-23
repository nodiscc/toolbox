#!/usr/bin/env python

"""
#Description: Generate README.md file with links to each submodule URL.
#For Github repositories, append the repository description to the link.
"""

import os
import requests
import subprocess
import json
import time
readme_contents = ""

#TODO: login or hit the API limit
#TODO: merge with markdown-describe-scripts.sh, so whe can have a readme with both submodules and simple script files

print "Getting subdirectories..."
dirz = os.walk('.').next()[1] #Get list of subdirectories
output_path = 'LIST.md'
outfile = open(output_path, 'w+')

#Store the main repo's remote URL; it will allows us to compare subdirectories' remote URLs to know if they are submodules or not
origin_check = subprocess.Popen("git remote show origin | grep 'Fetch URL:' | awk -F ' ' '{print $3}'", shell=True, env={"LANG": "C"}, stdout=subprocess.PIPE)
origin_url = origin_check.stdout.read()
print "origin_url is %s" % origin_url

#Loop through each subdirectory
for subdir in dirz: #TODO: store the remote url when we are here
    print "Changing dir to %s..." % subdir
    os.chdir(subdir)
    print "Getting origin..."
    repo_check = subprocess.Popen("git remote show origin | grep 'Fetch URL:' | awk -F ' ' '{print $3}'", shell=True, env={"LANG": "C"}, stdout=subprocess.PIPE) #Get remote URL for the subdirectory #BUG: if the remote is not named origin, it will fail
    repo_url = repo_check.stdout.read()
    if "https://github.com/" not in repo_url: #Check if the repo is on github
        isgithub = 0
        print "Not a github repo"
        markdownline = " * [" + subdir + "](" + subdir + ") - "
        outfile.write(markdownline)
    else:
        isgithub = 1
        print "It's a github repo"
    
    
    if isgithub == 1:
        if repo_url == origin_url: #Compare remote URL to the main repo's URL to know if we are in a submodule
            print "We are not in a submodule, moving along."
            markdownline = " * [" + subdir + "](" + subdir + ") - "
            outfile.write(markdownline)
            pass
        else:
            githubname = repo_url.split('/')[3] + "/" + repo_url.split('/')[4] #Get github's format for repos names (user/repo)
            apiurl = "https://api.github.com/repos/" + githubname.replace("\n","") #Get API info for the repo
            print "Getting API data..."
            apidata = requests.get(apiurl).json()
            description = apidata.get("description").encode('ascii', 'ignore') #Extract repo description for JSON returned by the API
            print "Generating markdown..."
            markdownline = " * [" + subdir + "](" + subdir + ") - " + description + " (" + repo_url.replace("\n","") + ")" #Generate markdown
            outfile.write(markdownline)
            time.sleep(1) #Sleep to prevent triggering Github's rate limiting
    
    print "Back to parent dir..."
    os.chdir ('..')

outfile.close