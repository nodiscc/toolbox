# toolbox.reverse_ssh_tunnel

This role will setup a [reverse SSH tunnel](https://www.howtoforge.com/reverse-ssh-tunneling) to a _remote_ host, that allows connecting back to the host (_local_) through the established tunnel. This tunnel can be used if the _local_ host's SSH server cannot be reached directly from the Internet (for example if you have no control over the NAT device between the Internet and the host, or a firewall prevents inbound connections to the host).


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: local.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # optional, firewall, ssh hardening, bruteforce protection, user configuration
    - nodiscc.toolbox.reverse_ssh_tunnel

# host_vars/local.CHANGEME.org/local.CHANGEME.org.yml
reverse_ssh_tunnel_local_user: "CHANGEME"
reverse_ssh_tunnel_privatekey: "/home/CHANGEME/.ssh/id_rsa"
reverse_ssh_tunnel_listen_port: 19997
reverse_ssh_tunnel_remote_host: "tunnel.CHANGEME.org"
reverse_ssh_tunnel_remote_user: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

The public key corresponding to the private key set in `reverse_ssh_tunnel_privatekey` must be allowed to connect to the `reverse_ssh_tunnel_local_user` user account on the remote end of the tunnel. 

```bash
# on the local end of the tunnel
cat /home/$reverse_ssh_tunnel_local_user/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAAD45QABAAACA3DJKlvlM7sniKbBj2xmR.....
# copy this value to public_keys/USER@my.CHANGEME.org.pub on the controller
```

And create a user at the remote end of the tunnel, for example using the [common](../common) role:

```yaml
linux_users:
  - name: $reverse_ssh_tunnel_local_user
    ssh_authorized_keys:
      - "public_keys/USER@my.CHANGEME.org.pub"
```

## Usage

On the _remote_ host, connect back to the _local_ end of the tunnel using

```bash
ssh -p {{ reverse_ssh_tunnel_listen_port }} {{ reverse_ssh_tunnel_local_user }}@localhost
```

### Using ansible through a reverse SSH tunnel/jump host

TODO

## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://github.com/nodiscc/tooblox/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/reverse_ssh_tunnel
- https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/reverse_ssh_tunnel
- https://stdout.root.sx/links/?searchterm=ssh
