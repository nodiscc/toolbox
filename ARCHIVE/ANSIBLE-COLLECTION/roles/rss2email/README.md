# toolbox.rss2email

This role will install [rss2email](https://github.com/rss2email/rss2email), a tool which forwards RSS feeds to your email address.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, outgoing mail
    - nodiscc.xsrv.monitoring # (optional) server health/performance/scheduled task monitoring
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.toolbox.rss2email

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
rss2email_email_address: CHANGEME@CHANGEME.org
rss2email_feeds:
  - name: shaarli
    url: https://github.com/shaarli/Shaarli/releases.atom

```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

A working `sendmail` program/configuration must be installed on the system for rss2email to be able to send mail - for example using the [`nodiscc.xsrv.common`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common)) role (see variables named [`*msmtp*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L345))

## Usage

rss2email will run every hour at the 11th minute, fetch configured feeds, and send email for every item in the feed which was not seen before.

**Run rss2email manually:** Run `sudo -u rss2email r2e run` or `sudo systemctl restart rss2email.service` on the host.

**Errors in rss2email logs:** rss2email will output `[ERROR] invalid feed configuration 'None' ...` when a feed was remove dfrom the configuration (`rss2email_feeds`), but is till present in the state/cache file at `/var/rss2email/.local/share/rss2email.json`. This doesn't prevent the progam from working correctly. To get rid of the error, manually remove the cached entries using `sudo -u rss2email r2e delete $FEED_NAME` on the host


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_rss2email.conf.j2) for the [backup](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/backup) role.

## Tags

<!--BEGIN TAGS LIST-->
```
rss2email - setup rss2email
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=rss
