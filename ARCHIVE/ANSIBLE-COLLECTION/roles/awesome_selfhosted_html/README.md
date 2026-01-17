# toolbox.awesome_selfhosted_html

This role deploys the [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted-html) static website. A live version is available at **[awesome-selfhosted.net](https://awesome-selfhosted.net)**


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
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

When `awesome_selfhosted_html_https_mode: letsencrypt`, DNS record for `awesome_selfhosted_html_fqdn` pointing to the web server. Additionally, when `awesome_selfhosted_html_redirect_www_to_non_www: yes` (the default), DNS record for www.`awesome_selfhosted_html_fqdn` pointing to the web server.

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
