# nodiscc.toolbox

Less-maintained/experimental ansible [roles](roles/)

## Installation

- [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 2.12 or later
- Install the collection:

```yaml
# requirements.yml
  - name: nodiscc.toolbox
    source: git+https://gitlab.com/nodiscc/toolbox.git#/ARCHIVE/ANSIBLE-COLLECTION/ # collection from a directory in a git repository
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
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) for more details.
See [xsrv](https://xsrv.readthedocs.io/) for production-ready roles.
