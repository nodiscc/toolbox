#!/usr/bin/env make
# Requirements: aria2c
LANG = C

define call_aria2c
	aria2c --dir=$(1) --input-file=$(2) --continue --console-log-level=warn --auto-file-renaming=false --allow-overwrite=true --timeout=3 --user-agent="Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0"
endef

all: mirror

mirror:
	$(call call_aria2c,BIN-LINUX/,bin-linux.urls.list)
	$(call call_aria2c,BIN-MAC/,bin-mac.urls.list)
	$(call call_aria2c,BIN-WINDOWS/,bin-windows.urls.list)
	$(call call_aria2c,BIN-DATA/,bin-data.urls.list)
