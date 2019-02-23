#!/bin/bash
#Description: Send a destkop notification when package upgrades are available
#Author: nodiscc (nodiscc@gmail.com)
#License: MIT (http://opensource.org/licenses/MIT)


_Notify() {
	notify-send \
	--expire-time=60000 \
	--icon="synaptic" \
	"Software updates available" \
	"There are $num_upgrades_avail software package update available. Run <b>Synaptic package manager</b> then press <b>Mark all upgrades</b> and <b>Apply</b>"
}

num_upgrades_avail=$(aptitude search ~U | wc -l)


if [ "$num_upgrades_avail" == "0" ]
	then exit 0
	else _Notify
fi

