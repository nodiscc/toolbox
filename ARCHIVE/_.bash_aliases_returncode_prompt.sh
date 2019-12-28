#!/bin/bash
# Description: ~/.bashrc snippet to show a red or green square before the prompt to incidicate return code of previous command

function __exit_code_block() {
	if [[ "$?" == 0 ]]; then
		echo -e "\033[01;32m█\033[00m"
	else
		echo -e "\033[01;31m█\033[00m"
	fi
}
PS1='$(__exit_code_block)\[\033[00m\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w $(__git_ps1 "(%s)")\[\033[00m\]\$ '

