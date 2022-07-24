# xsrv.autoreadme

This role automatically inserts useful host information in your project's README.md file.

<!--TODO screenshots -->

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

This role is meant to be used from a one-shot, [ad-hoc]() ansible command. Adding the role to your playbook is not needed.

```bash
# from ansible command-line
ansible --module-name "ansible.builtin.include_role" --args "name=nodiscc.toolbox.autoreadme"  --verbose --diff --connection local localhost
```

The role must be run **after** other roles have been deployed to your hosts, as it uses [local facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html) installed by other roles/gathered by the [setup](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/setup_module.html) module to retrieve information which will be included in the README.md.

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage


To control where the automatically added section appears in the README.md file, add/adjust the position of these markers in the file:

```markdown
<!-- BEGIN AUTOMATICALLY GENERATED CONTENT - AUTOREADME ROLE -->
<!-- END AUTOMATICALLY GENERATED CONTENT - AUTOREADME ROLE -->
```

The [default template](templates/autoreadme.md.j2) adds quick access links to services managed by the [xsrv](https://xsrv.readthedocs.io/ collection, and generates a SSH client configuration that can be installed to `~/.ssh/$project.conf`. It also supports these variables (add them to each host's `host_vars` files):

```yaml
# free-form comment or description (markdown is supported), such as physical location/hosting provider/link to the VM console/serial number...
autoreadme_comment: "[hypervisor 1 VM 112](https://proxmox1.CHANGEME.org:8006/#v1:0:=qemu%2F112:4:::::8::)"
# example using multi-line YAML comment - https://yaml-multiline.info/
autoreadme_comment: |
  ![](https://my.CHANGEME.org:19999/api/v1/badge.svg?chart=systemdunits_service-units.service_unit_state&alarm=systemd_service_units_state&refresh=auto)
  ![](https://my.CHANGEME.org:19999//api/v1/badge.svg?chart=logcount.messages&alarm=logcount_error&refresh=auto)
# public TCP port for netdata access, if netdata is behind a NAT/port forwarding
autoreadme_netdata_public_port: 19901
```

You may also use your own/customized template instead:

```yaml
# host_vars/localhost/localhost.yml
autoreadme_template: '{{ playbook_dir }}/data/templates/mycompany.autoreadme.j2
```

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=ansible
- https://stdout.root.sx/links/?searchtags=markdown
- https://stdout.root.sx/links/?searchterm=jinja
