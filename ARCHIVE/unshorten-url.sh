#!/bin/bash
#Description: Unshortens a shortened URL
#License: MIT (http://opensource.org/licenses/MIT)
#Source: https://github.com/nodiscc/scriptz

if [ -z "$1" ]
	then echo "USAGE: $(basename $0) SHORT_URL"; exit 1
fi

LONGURL=`curl -s http://api.unshorten.it?shortURL=$1\&apiKey=Injgj4PqDf4AcikibfgjAUN9yq9YlseP`
#If there was an error, return the original url
if [[  "$LONGURL" == *error* ]]
then
	echo $1
#If unshortened url does not contain http, something went wrong, return the
#original url...
elif [[ ! "$LONGURL" == *http* ]]
then
	echo $1
else
	echo $LONGURL
fi
