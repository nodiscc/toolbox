# toolbox.lynis

This role will install [Lynis](https://cisofy.com/lynis/), a security auditing tool for Unix-based systems, and configure it to run automated daily security scans.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring
    - nodiscc.toolbox.lynis

```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

## Usage

Lynis will run automated daily security scans and send email notifications when issues are found. The scan results will be available at `/var/log/lynis-report.txt`.

The default configuration includes custom settings that skip certain tests that are not applicable to this system's setup, such as password aging requirements, firewall configurations, and other security measures that are handled differently in this environment.

To run a manual Lynis scan:

```bash
sudo lynis audit system
```

To view the latest scan results:

```bash
cat /var/log/lynis-report.txt
```

```



## Tags

<!--BEGIN TAGS LIST-->
```
lynis - setup lynis security audit tool
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)

## References

- https://stdout.root.sx/links/?searchterm=lynis
- https://stdout.root.sx/links/?searchtags=security
