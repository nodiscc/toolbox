# toolbox.homepage_extra_icons

This role installs additional icons for the [nodiscc.xsrv.homepage](`https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage/`) role, which can be used in the `icon:` keys of `homepage_custom_links`.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - ...
    - nodiscc.xsrv.homepage
    - nodiscc.toolbox.homepage_extra_icons
```


## Tags

<!--BEGIN TAGS LIST-->
```
homepage-extra-icons - install additional icons for the nodiscc.xsrv.homepage role
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)

## References

- https://stdout.root.sx/links/?searchterm=icons
