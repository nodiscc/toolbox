#!/bin/bash
#Description: Mount an archive file with gvfs
#Source: https://andy.wordpress.com/2008/09/17/urlencode-in-bash-with-perl/
ENCODED=$(echo -n "$@" | perl -pe's/([^-_.~A-Za-z0-9])/sprintf("%%%02X", ord($1))/seg');
gvfs-mount "archive://$ENCODED"