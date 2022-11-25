# xsrv.nfs_server

This role will install and configure a [NFS](https://en.wikipedia.org/wiki/NFS) file server.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.toolbox.nfs_server
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

Mount exported NFS shares on allowed clients in `/etc/fstab`:

```bash
# $ sudo nano /etc/fstab
192.168.1.100:/home/client1    /mnt/nfs/home/client1    nfs    rw,sync,hard,intr,nosuid,nodev,noexec,_netdev
192.168.1.100:/home/client2    /mnt/nfs/home/client2    nfs    rw,sync,hard,intr,nosuid,nodev,noexec,_netdev
# $ sudo mount -a
```

## Tags

<!--BEGIN TAGS LIST-->
```
nfs-server - setup NFS server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=nfs
