#!/bin/bash
#Description: show a random commandlinefu.com command
#Source: http://matutine.cmoi.cc/posts/festival-de-commandes-bash-en-une-ligne-suite.html
#Copyright © 2015 Matutine <v.nce@gresille.org>

echo -e "`curl -sL http://www.commandlinefu.com/commands/random/json|sed -re 's/.*,"command":"(.*)","summary":"([^"]+).*/\\x1b[1;32m\2\\n\\n\\x1b[1;33m\1\\x1b[0m/g'`\n"
