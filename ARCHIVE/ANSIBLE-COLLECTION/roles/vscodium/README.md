# toolbox.vscodium

This role will install [vscodium](https://vscodium.com/), a Free/Libre Open Source Software distribution of [Visual Studio code](https://code.visualstudio.com/)].

[![](https://vscodium.com/img/vscodium.png)](https://vscodium.com/img/vscodium.png)


## Requirements/dependencies/vscodium playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.toolbox.vscodium
```

There are no configuration variables for this role.

This role is designed for deployment on an already working desktop environment (tested on Debian 12/XFCE).


## Usage

https://github.com/VSCodium/vscodium/blob/master/docs/index.md


### Backups

None. You may backup your `~/.vscode-oss/` directory manually.


## Tags

<!--BEGIN TAGS LIST-->
```
vscodium - setup vscodium text/source code editor/IDE
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=editor
