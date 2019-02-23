#!/bin/bash
#Description: generate 3 random words

function checkword() {
sed `perl -e "print int rand(99999)"`"q;d" /usr/share/hunspell/en_US.dic >> checkword
}

while [ `cat checkword 2>/dev/null | wc -l` -ne "3" ]; do checkword; done
cat checkword|awk -F '[/ \t]' '{print $1}'
rm checkword
