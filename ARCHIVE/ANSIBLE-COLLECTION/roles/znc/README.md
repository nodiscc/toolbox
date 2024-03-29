# toolbox.znc

This role will install [ZNC](https://en.wikipedia.org/wiki/ZNC), an IRC network bouncer or BNC.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.toolbox.znc
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

**Pidgin:** The correct format for the `Password` field is `ZNC_USERNAME/ZNC_NETWORK:ZNC_PASSWORD` [[1]](https://wiki.znc.in/Pidgin). For example, for this `znc_user`, the password in pdigin account settings should be `myusername/irc.libera.chat:CHANGEME`:
```yaml
- nickname: myusername
  password: CHANGEME
  networks:
    - server: irc.libera.chat
```


### Backups

TODO


### Uninstallation

Use the `utils-znc-uninstall` ansible tag (`TAGS=utils-znc-uninstall xsrv deploy default my.CHANGEME.org`)

## Tags

<!--BEGIN TAGS LIST-->
```
znc - setup ZNC IRC bouncer
utils-znc-uninstall - (manual) uninstall ZNC IRC bounder
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://wiki.znc.in/Pidgin
- https://wiki.znc.in/ZNC
- https://wiki.znc.in/Configuration
- https://wiki.znc.in/FAQ
- https://wiki.znc.in/Modules
- https://wiki.znc.in/Fail2ban
- https://wiki.archlinux.org/title/ZNC
- https://wiki.debian.org/ZNC
