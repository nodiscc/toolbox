# toollbs.nfs_server

This role will install a [NFS](https://en.wikipedia.org/wiki/Network_File_System) file server and allows configuring NFS shares.


## Requirements/dependencies/example playbook

See [meta/main.yml](defaults/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common # optional
     - nodiscc.xsrv.monitoring # optional
     - nodiscc.xsrv.nfs_server

# host_vars/my.example.org/my.example.org.yml
nfs_shares:
  - path: /home/client1 # path to the shared directory
    client: "10.0.0.10.101"
  - path: /home/client2
    owner: root
    group: root
    client: "10.0.10.0/24"
    options: "rw,sync,no_subtree_check,async"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Mount shares from an authorized client, for example using the ansible [mount module](https://docs.ansible.com/ansible/latest/collections/ansible/posix/mount_module.html):

```yaml
- name: create nfs mountpoints
  file:
    path: "{{ item }}"
    state: directory
  with_items:
    - /mnt/nfs/home/client1
    - /mnt/nfs/home/client2

mount:
  - src: "10.0.0.100:/home/client1"
    dest: "/mnt/nfs/home/client1"
    type: nfs
    options: rw,sync,hard,intr,nosuid,nodev,noexec
    state: present
  - src: "10.0.0.100:/home/client2"
    dest: "/mnt/nfs/home/client2"
    type: nfs
    options: rw,sync,hard,intr,nosuid,nodev,noexec
    state: present
```

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=nfs
