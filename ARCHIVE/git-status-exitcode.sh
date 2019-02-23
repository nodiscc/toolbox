#!/bin/bash
# Description: Returns 1 if git status is not clean

cd /path/to/repo && if [[ $(git status --short) != "" ]]; then exit 1; fi