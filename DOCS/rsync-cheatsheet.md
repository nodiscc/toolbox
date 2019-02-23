### Rsync Cheatsheet

Rsync cheatsheet:

```
-a, --archive               archive mode; equals -rlptgoD (no -H,-A,-X)
-r, --recursive             recurse into directories
-l, --links                 copy symlinks as symlinks
-p, --perms                 preserve permissions
-t, --times                 preserve modification times
-g, --group                 preserve group
-o, --owner                 preserve owner (super-user only)
-D                          same as --devices --specials
    --devices               preserve device files (super-user only)
    --specials              preserve special files
-z, --compress              compress file data during the transfer
-P                          same as --partial --progress
    --existing              skip creating new files on receiver
    --remove-source-files   sender removes synchronized files (non-dir)
-u, --update                skip files that are newer on the receiver
    --delete                delete extraneous files from dest dirs (CAUTION!)']
```


