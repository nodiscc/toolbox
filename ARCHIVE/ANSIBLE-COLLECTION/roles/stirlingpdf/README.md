# toolbox.stirlingpdf

This role will install [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF), a tool to carry out various operations on PDF files, including splitting, merging, converting, reorganizing, adding images, rotating, compressing, and more.

Stirling PDF will be deployed as a rootless [podman](../podman) container managed by a systemd service.

![](https://github.com/Stirling-Tools/Stirling-PDF/raw/main/images/stirling-home.jpg)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.toolbox.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.toolbox.monitoring # (optional) apache monitoring
    - nodiscc.toolbox.apache # (required in the standard configuration) reverse proxy and SSL certificates
    - nodiscc.toolbox.podman # container engine
    - nodiscc.toolbox.stirlingpdf

# required variables:
stirlingpdf_fqdn: "pdf.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Uninstallation

```bash
sudo systemctl --machine stirlingpdf@ disable container-stirlingpdf.service --now --user
cd / && sudo -u stirlingpdf podman rm -f stirlingpdf
sudo killall --user stirlingpdf
sudo userdel -r stirlingpdf
sudo a2dissite stirlingpdf
sudo rm -rf /var/lib/stirlingpdf /etc/apache2/sites-available/stirlingpdf.conf /etc/ansible/facts.d/stirlingpdf.fact
sudo systemctl reload apache2
```

## Tags

<!--BEGIN TAGS LIST-->
```
stirlingpdf - setup Stirling PDF PDF manipulation tools
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)
