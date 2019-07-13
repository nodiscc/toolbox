#!/bin/bash
set -o errexit
set -o nounset

gitea_cli_path="/usr/local/bin/gitea"

"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-apache
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-docker
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-gitea
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-gitlab-runner
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-icecast
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-monitoring
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-mumble
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-nextcloud
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-openldap
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-pulseaudio
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-samba
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-shaarli
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-transmission
"$gitea_cli_path" --description '' --private new zerodb/ansible-svr-tt-rss


gitlab project create --name ansible-svr-apache --description 'apache web server - ansible role' --visibility public
gitlab project create --name ansible-svr-common --description 'Debian base system configuration - ansible role' --visibility public
gitlab project create --name ansible-svr-docker --description 'Docker container management system - ansible role' --visibility public
gitlab project create --name ansible-svr-gitea --description 'Gitea self-hosted git service - ansible role' --visibility public
gitlab project create --name ansible-svr-gitlab-runner --description 'Gitlab-runner Continuous Integration service - ansible role' --visibility public
gitlab project create --name ansible-svr-icecast --description 'Icecast media streaming server - ansible role' --visibility public
gitlab project create --name ansible-svr-monitoring --description 'Netdata monitoring system and additional tools - ansible role' --visibility public
gitlab project create --name ansible-svr-mumble --description 'Mumble VoIP server - ansible role' --visibility public
gitlab project create --name ansible-svr-nextcloud --description 'Nextcloud private cloud/groupware - ansible role' --visibility public
gitlab project create --name ansible-svr-openldap --description 'OpenLDAP directory server and administration tools - ansible role' --visibility public
gitlab project create --name ansible-svr-pulseaudio --description 'Pulseaudio network sound server - ansible role' --visibility public
gitlab project create --name ansible-svr-samba --description 'Samba file sharing server - ansible role' --visibility public
gitlab project create --name ansible-svr-shaarli --description 'Shaarli bookmark/link sharing application - ansible role' --visibility public
gitlab project create --name ansible-svr-transmission --description 'Transmission bittorrent client and web interface - ansible role' --visibility public
gitlab project create --name ansible-svr-tt-rss --description 'Tiny Tiny RSS RSS/ATOM feed reader web application - ansible role' --visibility public
