# toolbox.valheim_server

This role will install and configure [Valheim](https://en.wikipedia.org/wiki/Valheim) multiplayer server using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD)

## Dependencies/requirements/example playbook

- See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.toolbox.valheim_server

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
steamcmd_username: "CHANGEME"
steamcmd_password: "CHANGEME"
steamcmd_guard_code: "CHANGEME"
valheim_server_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

A [Steam](https://store.steampowered.com/) account is required. It is recommended to create a dedicated steam account, as the credentials are stored on the server (installing valheim server does not require buying valheim with the account).

On first deployment, leave `steamcmd_guard_code: "CHANGEME"`. The role will fail and a guard code will be sent to you by mail - then set `steamcmd_guard_code` to the correct value (example `steam_guard_code: "ZBLX6UY"`) and apply the role again.

If your server is behind a NAT/port forwarding device, the following ports must be forwarded to the server:

```
TCP 2456-2457
TCP 27015
TCP 27030
TCP 27036-27037
UDP 2456-2457
UDP 4380
UDP 27000-27031
UDP 27036
```

## Backups

`/home/steam/.config/unity3d/IronGate/Valheim` must be backed up. Example using the `backup` role from a remote server:

```yaml
rsnapshot_remote_backups:
  - { user: 'rsnapshot', host: 'valheim.CHANGEME.org', path: '/home/steam/.config/unity3d/IronGate/Valheim' }
```
