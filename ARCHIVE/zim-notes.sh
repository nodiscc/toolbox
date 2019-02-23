#!/bin/bash
#Description: Manage your notes with Zim http://zim-wiki.org/
set -e

USAGE="USAGE: $0 [ -h|--help ] [ a|add ] [ t|tasks ] [ @ ] \"text\"
	$0 			Show all notes
	$0 -h, --help		Show this help message
	$0 a, add \"note text\"	Add \"note text\" in a new note
	$0 t, tasks		List todos/tasks in notes
	$0 @			List all tags
	$0 j			jump to notebook dir #todo 
	$0 \"text\"		Search notes for \"text\"
"

NS=`date +%Y:%m`
BN=`date +%d`

#URI style decoding, needed as sometimes (not always?) zim stores notebook paths uri-encoded
function urldecode(){
	python -c "import sys, urllib as ul; print ul.unquote_plus('$1')" ;
}

#Get default notebook path from config file
NOTEBOOK=$(urldecode $(grep -A1 "Default" ~/.config/zim/notebooks.list | tail -n 1 | sed -e "s|~|$HOME|" -e "s|file://||g"))

#Ignore pages metadata
IGNOREPATTERN="Content-Type:|Wiki-Format:|Creation-Date:"


#List all notes, sorted
function _ListNotes() {
	find "$NOTEBOOK" -name "*.txt" | sort| xargs cat | egrep -v "$IGNOREPATTERN" | less
}

#Add a note to the current day page in the notebook
#TODO: skip the quick note dialog
function _AddNote() {
	zim --plugin quicknote notebook=Notes namespace="Calendar:$NS" basename="$BN" append=true text="$*"
}

#Filter/search in notes
function _FilterNotes() {
	egrep -ri --binary-files=without-match --color=always "$*" $NOTEBOOK |sed -e "s|$NOTEBOOK||g" -e "s|/Calendar/`date +%Y`/||g" -e "s/.txt//g" | sort
}

#List all tags
function _ListTags() {
	echo listtags
	egrep --binary-files=without-match --color=always --only-matching --no-filename -ir '@[^[:space:]]*' $NOTEBOOK |sort -u
}

#List all tasks
function _ListTasks() {
	egrep --binary-files=without-match --color=always -ir "\[ ]|@todo" "$NOTEBOOK" |sed -e "s|$NOTEBOOK||g" -e "s|/Calendar/`date +%Y`/||g" -e "s/.txt//g" | sort
	find "$NOTEBOOK" -name todo.txt | xargs cat | sed '/^$/d' | egrep -v "$IGNOREPATTERN" | sed '/^$/d'

}

function _Main() {
	if [ "$1" = "h" -o "$1" = "--help" -o "$1" = "-h" ]
		then echo "$USAGE"
	elif [ "$1" = "a" -o "$1" = "add" ]
		then shift; _AddNote "$*"
	elif [[ "$*" = "" ]]
		then _ListNotes
	elif [ "$1" = "t" -o "$1" = "tasks" ]
		then _ListTasks
	elif [[ "$1" = "@" ]]
		then _ListTags
	else
		_FilterNotes "$*"
	fi
	}

_Main "$@"
