#!/bin/sh
#Description: change committer name/email for all commits in a git repo
#Source: https://help.github.com/articles/changing-author-info

git filter-branch -f --env-filter '

an="$GIT_AUTHOR_NAME"
am="$GIT_AUTHOR_EMAIL"
cn="$GIT_COMMITTER_NAME"
cm="$GIT_COMMITTER_EMAIL"

if [ "$GIT_COMMITTER_EMAIL" = "falken@grutula" ]
then
    cn="nodiscc"
    cm="nodiscc@gmail.com"
fi
if [ "$GIT_AUTHOR_EMAIL" = "falken@grutula" ]
then
    an="nodiscc"
    am="nodiscc@gmail.com"
fi

export GIT_AUTHOR_NAME="$an"
export GIT_AUTHOR_EMAIL="$am"
export GIT_COMMITTER_NAME="$cn"
export GIT_COMMITTER_EMAIL="$cm"
'

