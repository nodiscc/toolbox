# toolbox.awesome_selfhosted_html

This role deploys the [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted-html) and optionally the [awesome-sysadmin](https://github.com/awesome-foss/awesome-sysadmin-html) static websites. Live versions are available at **[awesome-selfhosted.net](https://awesome-selfhosted.net) and [sysadmin.awesome-selfhosted.net](https://sysadmin.awesome-selfhosted.net).**


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.apache # web server and SSL/TLS certificates
    - nodiscc.toolbox.awesome_selfhosted_html

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
awesome_selfhosted_html_fqdn: "awesome-selfhosted.CHANGEME.org"
# optionally enable awesome-sysadmin static website deployment
awesome_sysadmin: true
awesome_sysadmin_fqdn: "awesome-sysadmin.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

* When `awesome_selfhosted_html_https_mode: letsencrypt`, DNS record for `awesome_selfhosted_html_fqdn` pointing to the web server. Additionally, when `awesome_selfhosted_html_redirect_www_to_non_www: yes` (the default), DNS record for www.`awesome_selfhosted_html_fqdn` pointing to the web server.
* When `awesome_sysadmin_https_mode: letsencrypt`, DNS record for `awesome_sysadmin_fqdn` pointing to the web server.

## Usage

<!--Notes about using the deployed service.-->


### Backups

There is no data worth backing up.

## Tags

<!--BEGIN TAGS LIST-->
```
awesome_selfhosted_html - setup awesome-selfhosted static website
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=awesome-selfhosted
- https://github.com/awesome-selfhosted/awesome-selfhosted-data
- https://github.com/awesome-selfhosted/awesome-selfhosted-html
