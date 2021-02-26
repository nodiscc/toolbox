#!/bin/bash
# Description: merge multiple git repositories in a single repo
# each old repository will be stored in a subdirectory at the root of the new repo
# history for 'master' branches will be kept
# history in non-master branches will be lost, each branch will appear as a single-commit branch on top of master
# branches will have the exact state/tree as they had before the merge, so expect regressions if your non-master branches are not rebased on master/master has not been merged back to them! REBASE YOUR BRANCHES ON MASTER before running this!
# this script does not push anything to remotes

new_repo="EXAMPLE"
base_url="https://git.EXAMPLE.org/EXAMPLE"
repos="project1 project2 project3 project4 project5 project6 project7 project8 project9"

# initialize an empty repository
git init $new_repo && cd $new_repo/ && git checkout -b single-repo && touch .empty && git add .empty && git c -m "initial commit"
# store credentials in cache
git config credential.helper store


# add all repositories as remotes and fetch
for repo in $repos; do
    git remote add $repo $base_url/$repo
    git remote update
done
git fetch --all --tags

read -n -p "[INFO] This is your current state (histories from all repositories, imported to a single repo). Check git graph now. Press enter to continue"

# for each remotename/branchname remote branch, create a new remotename-branchname local branch 
allbranches=$(git b --no-merged|sed 's|remotes/||g')
for branch in $allbranches ; do
    newbranchname=$(echo $branch | sed 's|/|-|g');
    git checkout -b $newbranchname $branch
done

# in each remotename/branchname remote branch, move all  files in a remotename subdirectory
shopt -s dotglob
for repo in $repos; do
    repo_branches=$(git b | grep remotes/$repo | sed 's|remotes/||');
    for branchname in $(echo $repo_branches | sed 's|/|-|g'); do
        git checkout $branchname;
        mkdir $repo;
        git mv -k * $repo/;
        git add --all .;
        git commit -m "merge git repositories: import $repo in subdirectory";
    done;
done

# remote remotes, we no longer need them
for repo in $repos; do
    git remote remove $repo
done

# create a new, orphan branch (with no commits, clear contents)
git checkout --orphan master
git rm --cached -f -r .
git clean -dff

# merge all remotename-branchname branches in master (keep history)
for repo in $repos; do
git merge -m "merge branch $repo-master" --allow-unrelated-histories $repo-master
git branch -d $repo-master
done

# for each non-master branch:
# - create a new rebase-remotename-branchname branch
# - checkout the exact state of the original branch (not mergeable without conflicts)
# - add everything as one single commit
# this will cause regressions on branches where master has not been merged back, so better rebase/merge master in all branches before running this!
for repo in $repos; do
    repo_branches=$(git branch | grep "^ *$repo" | grep -v master);
    for branch in $repo_branches; do
        git checkout -b rebase-$branch
        git checkout $branch $repo
        git commit -m "rebase branch: $branch"
        git checkout master
        git branch -D "$branch"
    done
done
