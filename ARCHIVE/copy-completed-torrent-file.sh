#!/bin/bash
# Description: transmission - on download completion, copy the corresponding torrent file from cache to torrent download directory
# Authors: nodiscc (nodiscc@gmail.com)
# License: Public Domain
# Doc: https://trac.transmissionbt.com/wiki/Scripts

partial_hash=$(echo -n "$TR_TORRENT_HASH" | cut --characters=-16)
cp "$HOME/.config/transmission/torrents/*.$partial_hash.torrent" "$TR_TORRENT_DIR/"
