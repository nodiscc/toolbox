# toolbox.pulseaudio

This role will install the [PulseAudio](https://en.wikipedia.org/wiki/Pulseaudio) sound server.
It allows you to stream audio from a computer (all sounds or only selected applications) on your network to the server's soundcard output. Your devices can play sound to speakers connected to the server.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/GbWW8aF.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/GbWW8aF.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall
    - nodiscc.toolbox.pulseaudio
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

The server's firewall must allow connections from clients on port `4731/tcp`. This is done automatically if the `nodiscc.xsrv.common / firewalld` role is deployed.

## Usage

Any computer running PulseAudio on the same local network as the server can stream audio to it.

**Automatic client configuration:** The output sink is announced over the network using Avahi, so any computer on the same LAN (with `pulseaudio-module-zeroconf` installed) should detect the output sink and make it available as a sound device in your audio mixer ([pavucontrol](https://packages.debian.org/stretch/pavucontrol)). Simply select this output device for your applications.

If you do not see the ouput sink in your mixer, make sure `Make discoverable PulseAudio network sound devices availabe locally` is enabled in Pulseaudio Preferences ([paprefs](https://packages.debian.org/stretch/paprefs)), and that `avahi-daemon` is installed and started.

A shared cookie is used to allow access to the pulseaudio server. To configure the client, you must either copy the cookie manually from the server `/var/run/pulse/.config/pulse/pulse-cookie` to `~/.config/pulse/cookie` on the client (and restart/kill pulseaudio on the client / `pulseaudio -k`), or set `pulseaudio_configure_local_cookie: yes` in the config file if the client is the controller.

**Manual client configuration:** TODO

**Uninstallation:**

```bash
# to revert to a classic desktop configuration
$ sudo firewall-cmd --zone internal --remove-service=pulseaudio
$ sudo systemctl stop pulseaudio.service avahi-daemon.service
$ sudo rm -r /etc/systemd/system/pulseaudio.service /etc/avahi/avahi-daemon.conf /var/run/pulse
$ sudo systemctl daemon-reload
$ sudo apt purge avahi-daemon avahi-utils alsa-oss libasound2-plugin-equal pulseaudio-module-zeroconf
$ sudo apt install --reinstall libpulse0 pulseaudio
$ sudo deluser pulse
$ rm ~/.config/pulse/cookie
```

## License

GNU GPLv3

## References

- https://stdout.root.sx/links/?searchtext=pulseaudio
- https://stdout.root.sx/links/?searchtext=avahi
