# nodiscc.toolbox

Less-maintained, experimental or project-specific ansible [roles](roles/).

<!--BEGIN ROLES LIST-->
- [awesome_selfhosted_html](roles/awesome_selfhosted_html) - awesome-selfhosted static website
- [bitmagnet](roles/bitmagnet) - BitTorrent DHT crawler
- [docker](roles/docker) - application containerization platform
- [grafana](roles/grafana) - Analytics and interactive visualization web application
- [homepage_extra_icons](roles/homepage_extra_icons) - additional icons for the nodiscc.xsrv.homepage role
- [icecast](roles/icecast) - media streaming server
- [k8s](roles/k8s) - Container management platform/orchestrator
- [mariadb](roles/mariadb) - MariaDB database engine
- [nfs_server](roles/nfs_server) - NFS file server
- [planarally](roles/planarally) - virtual tabletop (VTT)
- [prometheus](roles/prometheus) - monitoring service and time-series database
- [proxmox](roles/proxmox) - Proxmox VE hypervisor configuration
- [pulseaudio](roles/pulseaudio) - local network sound server
- [rocketchat](roles/rocketchat) - instant messaging & communication platform
- [rss2email](roles/rss2email) - receive RSS feeds by email
- [rss_bridge](roles/rss_bridge) - generate RSS feeds for websites missing them
- [valheim_server](roles/valheim_server) - Valheim multiplayer server
- [vscodium](roles/vscodium) - free/Libre and Open-Source distribution of the VSCode text/source code editor/IDE
- [znc](roles/znc) - IRC bouncer
<!--END ROLES LIST-->

## Installation

- [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 2.12 or later
- Install the collection:

```yaml
# requirements.yml
  - name: https://gitlab.com/nodiscc/xsrv.git
    type: git
    version: release
  - name: git+https://gitlab.com/nodiscc/toolbox.git#/ARCHIVE/ANSIBLE-COLLECTION/ # collection from a directory in a git repository
    type: git
    version: master
```

```bash
ansible-galaxy collection install -r requirements.yml
```

- Include roles from the collection in your playbook:

```yaml
- hosts: my.CHANGEME.org
  roles:
   - nodiscc.toolbox.pulseaudio
   - nodiscc.toolbox.mariadb
   - nodiscc.toolbox.reverse_ssh_tunnel
   - nodiscc.toolbox.nfs_server
   - nodiscc.toolbox.valheim_server
   - nodiscc.toolbox.icecast
   - nodiscc.toolbox.rss_bridge
   - nodiscc.toolbox.rocketchat
   - nodiscc.toolbox.proxmox
   - nodiscc.toolbox.znc
   - nodiscc.toolbox.homepage_extra_icons
   - nodiscc.toolbox.awesome_selfhosted_html
   - nodiscc.toolbox.docker
   - nodiscc.toolbox.planarally
   - nodiscc.toolbox.k8s
   - nodiscc.toolbox.vscodium
   - nodiscc.toolbox.bitmagnet
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) for more details.
See [xsrv](https://xsrv.readthedocs.io/) for production-ready roles.
