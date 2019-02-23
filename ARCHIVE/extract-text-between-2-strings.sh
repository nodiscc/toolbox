#!/bin/bash
#Description: extract text between two strings
# https://stackoverflow.com/a/13245961
#Licence: CC-BY-SA http://creativecommons.org/licenses/by-sa/3.0/
# example: cat sitemap.xml |  grep -o -P '(?<=\<link\>\<\!\[CDATA\[).*(?=\]\]\>\<\/link\>)'
#replace first-string and end-string with your own
grep -o -P '(?<=first-string).*(?=end-string)'