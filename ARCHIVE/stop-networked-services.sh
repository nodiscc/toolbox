#!/bin/bash
#Description: stop all network related services
set -o errexit
rfkill block all
service network-manager stop
service cups stop
service ntp stop
service avahi-daemon stop
service bluetooth stop
service cups-browsed stop
service dnscrypt-proxy stop
service dnsmasq stop
service fail2ban stop
service iodined stop
service nmbd stop
service openvpn stop
service rsync stop
service samba stop
service samba-ad-dc stop
service smbd stop
service ssh stop
killall ssh
killall gvfsd-smb-browse
macchanger -a wlan0
sed -i -e 's/^send host-name.*/send host-name: "uwiac32a"/g' /etc/dhcp/dhclient.conf
ufw enable
ufw status verbose
