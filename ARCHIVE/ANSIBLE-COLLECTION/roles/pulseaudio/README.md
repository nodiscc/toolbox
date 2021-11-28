pulseaudio
=============

This role will install the [PulseAudio](https://en.wikipedia.org/wiki/Pulseaudio) sound server. It allows you to stream audio from a computer (all sounds or only selected applications) on your network to the server's soundcard output. Your devices can play sound to speakers connected to the server.


Clients
------------

Any computer running PulseAudio on the same local network as the server can stream audio to it.

**Automatic configuration:** The output sink is announced over the network using Avahi, so any computer on the same LAN (with `pulseaudio-module-zeroconf` installed) should detect the output sink and make it available as a sound device in your audio mixer ([pavucontrol](https://packages.debian.org/stretch/pavucontrol)). Simply select this output device for your applications.

If you do not see the ouput sink in your mixer, make sure `Make discoverable PulseAudio network sound devices availabe locally` is enabled in Pulseaudio Preferences ([paprefs](https://packages.debian.org/stretch/paprefs)), and that `avahi-daemon` is installed and started.

A shared cookie is used to allow access to the pulseaudio server. To configure the client, you must either copy the cookie manually to `~/.config/pulse/cookie` on the client (and restart/kill local pulseaudio), or set `pulseaudio_configure_local_cookie: yes` in the config file if the client is the controller.

**Manual client configuration:** TODO

Requirements
------------

This role requires Ansible 2.7 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)

Dependencies
------------

None

Example Playbook
----------------


License
-------

GNU GPLv3

References
-----------------

- https://manpages.debian.org/stretch/avahi-daemon/avahi.service.5.en.html