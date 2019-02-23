#!/bin/bash
#Description: view a mardown file as a manpage
#Source: https://www.reddit.com/r/UnixProTips/comments/38ffzc/read_markdown_files_like_man_pages/
pandoc -s -f markdown -t man "$*" | man -l -