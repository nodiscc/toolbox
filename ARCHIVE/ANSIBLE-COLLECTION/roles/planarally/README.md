# toolbox.planarally

This role will install [planarally](https://github.com/Kruptein/PlanarAlly), a virtual battle map for tabletop role-playing games

[![](https://raw.githubusercontent.com/Kruptein/PlanarAlly/dev/extra/player_light_example.png)](https://raw.githubusercontent.com/Kruptein/PlanarAlly/dev/extra/player_light_example.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.monitoring # (optional) server health monitoring
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.toolbox.planarally

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
planarally_fqdn: planarally.CHANGEME.org

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
# none
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

**See https://www.planarally.io/docs/**.

Planarally is currently missing support for d100/percentile dice rolls https://github.com/Kruptein/PlanarAlly/issues/966.

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_planarally.conf.j2) for the [backup](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/backup) role.


## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://www.planarally.io/server/setup/self-hosting/
- https://www.planarally.io/server/management/configuration/
- https://www.planarally.io/server/management/users/
- https://www.planarally.io/server/advanced/proxy/
- https://www.planarally.io/server/management/api/
