#!/bin/bash
#Description: example usage of getopts in bash (to parse command-line options)
#http://wiki.bash-hackers.org/howto/getopts_tutorial

#Example usage for your script
USAGE="$(basename $0) -a action -f filename [-s somevariable] [-m morevariables] [-t]
	action: 	to action to execute
	filename:	an example filename to use
	somevariable:	set some variable to the desired value
	morevariables:	set some other variable
	-t:		set option TOTO to 1"

#Getopts loop - the first : sets silent mode (less error reporting)
#An option followed by : (eg. a:) will require an argument
#Options without an : are simple flags and require no argument
while getopts ":a:c:s:m:tfh" opt; do
	case $opt in
	a) action=$OPTARG
	;;
	c) filename=$OPTARG
	;;
	s) somevariable=$OPTARG
	;;
	m) morevariables=$OPTARG
	;;
	t) TOTO="1"
	;;
	h) echo "$USAGE"; exit 0
	;;
	*) echo -e "${R}Invalid option $opt${NC}"; echo "$USAGE"; exit 1
	;;
	esac
done