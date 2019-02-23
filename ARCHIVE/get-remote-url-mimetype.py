#!/usr/bin/env python
#Description: get the mime-type of a file at a remote URL
'''
get mimetype of remote document
https://stackoverflow.com/questions/12474406/python-how-to-get-the-content-type-of-an-url
'''

res = urllib.urlopen("http://www.iana.org/assignments/language-subtag-registry" )
http_message = res.info()
full = http_message.type # text/plain
main = http_message.maintype # text
