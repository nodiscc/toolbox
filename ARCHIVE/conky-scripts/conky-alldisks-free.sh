#!/bin/bash
#Description : generate disk free space lines for all mounted disks as .conkyrc syntax
set -o errexit
set -o nounset


mounts=$(mount -t ext4,vfat)
echo "$mounts" | while read -r mount; do
	mountpoint=$(echo "$mount" | awk '{print $3}')
	display_name=$(echo "$mountpoint" | awk -F"/" '{print "/" $NF}')

	echo "\${color1}DISK $display_name\${color} FREE \${fs_free $mountpoint} \${color}"
done


