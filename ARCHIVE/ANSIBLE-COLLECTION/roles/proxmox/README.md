# toolbox.proxmox

This role will perform basic setup steps for [Proxmox](hhttps://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) hypervisors:
- setup `pve-no-subscription` APT repositories
- protect from bruteforce on the login form using `fail2ban` (if `nodiscc.xsrv.common` role is deployed)

> Proxmox Virtual Environment (Proxmox VE or PVE) is an open-source software server for virtualization management. It is a Debian-based Linux distribution and allows deployment and management of virtual machines and containers. Proxmox VE includes a web console and command-line tools.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/7DYZfcC.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/7DYZfcC.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening/bruteforce protection/automatic security upgrades
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.toolbox.proxmox
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

If the `nodiscc.xsrv.common` role is deployed to the same host:
- let proxmox manage the firewall (don't setup firewalld) by setting `setup_firewall: no`
- delete `/etc/pve/sources.list.d/{pve-enterprise,ceph}.list` and run `apt update` since these repositories require password authentication, and return 401 errors which causes initial deployment to fail.

## Usage

### Initial setup

**Create a non-root proxmox admin user:**
- Access `https://{{ inventory_hostname }}:8006` in a web browser
- Login as `root` with the password provided during proxmox installation
- Open the `Datacenter > Permissions > Groups` page
- Add a new group named `proxmoxadm` with description `proxmox administrators`
- Open the `Datacenter > Permissions > Users` page
- Create a new user named `myusername`, realm `Proxmox VE authentication server`, member of the `proxmoxadm` group, set a strong password for this user
- Open the `Datacenter > Permissions` page
- Click `Add > Group permission`
- Add a new permission with Path `/`, Group `proxmoxadm`, Role: `Administrator`


### Backups

Backup the `/etc/pve/` directory to backup proxmox configuration including VM definitions. Backup `/var/lib/vz/dump` to backup VM snapshots.

## Tags

<!--BEGIN TAGS LIST-->
```
proxmox - setup proxmox hypervisor
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterms=proxmox
- https://stdout.root.sx/links/?searchtags=virtualization
