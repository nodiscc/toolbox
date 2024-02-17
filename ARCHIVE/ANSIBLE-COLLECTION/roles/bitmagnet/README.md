# xsrv.bitmagnet

This role will install [bitmagnet](https://bitmagnet.io/en-us/)

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/4NhXqdG.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/d5glB4P.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.postgresql # (required in the standard configuration) database engine
    - nodiscc.xsrv.bitmagnet

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
bitmagnet_fqdn: "git.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
bitmagnet_db_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

### Backups

Database backups are handled by the [postgresql](../postgresql) role, if deployed.

## Tags

<!--BEGIN TAGS LIST-->
```
bitmagnet - setup bitmagnet BitTorrent DHT crawler
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://stdout.root.sx/links/?searchtags=p2p

