#!/bin/bash
# Description: view changes in a git repository since $1 days
set -o errexit
set -o nounset
days="$1"
git log --all --color --format=oneline --since="$days days ago" | less -R