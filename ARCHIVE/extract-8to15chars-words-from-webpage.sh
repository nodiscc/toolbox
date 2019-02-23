#!/bin/bash
#Description: extract 8 to 15 characters words from a webpage

curl $1 | \
html2text -width 600 | \
while read -a LINE; do echo "$LINE" >> words.txt; done
uniq words.list > uniqwords.list && rm words.list
grep -i '[a-z]\{8\}$' uniqwords.list
grep -i '[a-z]\{9\}$' uniqwords.list
grep -i '[a-z]\{10\}$' uniqwords.list
grep -i '[a-z]\{11\}$' uniqwords.list
grep -i '[a-z]\{12\}$' uniqwords.list
grep -i '[a-z]\{13\}$' uniqwords.list
grep -i '[a-z]\{14\}$' uniqwords.list
grep -i '[a-z]\{15\}$' uniqwords.list
