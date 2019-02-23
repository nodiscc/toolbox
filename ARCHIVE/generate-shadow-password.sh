#!/bin/bash
#Description: generate a password suitable for storage in /etc/shadow
usage="USAGE: $0 password salt"

if [[ -z "$1" || -z "$2" ]] ; then
	echo "$usage"; exit 1
fi
mkpasswd -m sha-512 password salt
