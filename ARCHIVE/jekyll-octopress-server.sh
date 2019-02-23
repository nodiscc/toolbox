#!/bin/bash
# Description: create and serve a static website with octopress/jekyll
# source: http://jvns.ca/blog/2014/10/07/how-to-set-up-a-blog-in-5-minutes/

# config
sitename="mysite"
baseurl="http://127.0.0.1:4000"


sudo gem install bundler minima octopress
rbenv rehash
mkdir octopress; cd octopress
octopress new "$sitename"
sed -i "s|http://example.com|$baseurl|g" "$sitename"/_config.yml
cd "$sitename"; jekyll serve