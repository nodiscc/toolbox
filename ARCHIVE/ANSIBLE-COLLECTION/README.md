# nodiscc.toolbox

Less-maintained ansible roles

## Installation

- [Install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) 2.12 or later
- Install the collection:

```yaml
# requirements.yml
  - name: nodiscc.toolbox
    source: git+https://gitlab.com/nodiscc/toolbox.git#/ARCHIVE/ANSIBLE-COLLECTION/ # role from a directory in a git repository
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
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) for more details.
