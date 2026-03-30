#!/bin/bash
# Description: Counts added/removed lines in git commits over the last N days
# Usage: ./count-recent-git-changes.sh <github_url> <N_days>
set -o errexit
set -o nounset

URL="$1"
N_DAYS="$2"

REPO_NAME=$(basename "$URL" | sed 's/\.git$//')
CLONE_DIR="./tmp-clone-${REPO_NAME}"

git clone "$URL" "$CLONE_DIR"

cd "$CLONE_DIR"

TOTAL_ADDED=0
TOTAL_REMOVED=0

while IFS= read -r hash; do
    [ -z "$hash" ] && continue
    STAT=$(git show --numstat --format="" "$hash")
    while IFS=$'\t' read -r added removed _; do
        [ -z "$added" ] && continue
        [[ "$added" =~ ^[0-9]+$ ]] || continue
        TOTAL_ADDED=$((TOTAL_ADDED + added))
        TOTAL_REMOVED=$((TOTAL_REMOVED + removed))
    done <<< "$STAT"
done < <(git log --since="${N_DAYS} days ago" --format="%H")

cd ..

echo -e "\033[32mAdded: ${TOTAL_ADDED}\033[0m"
echo -e "\033[31mRemoved: ${TOTAL_REMOVED}\033[0m"

rm -rf "$CLONE_DIR"
