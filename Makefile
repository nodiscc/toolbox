#!/usr/bin/env make
SHELL := '/bin/bash'
LANG = C
BIN_LINUX_DIR ?= MIRRORS/BIN-LINUX
BIN_MAC_DIR ?= MIRRORS/BIN-MAC
BIN_WINDOWS_DIR ?= MIRRORS/BIN-WINDOWS
BIN_DATA_DIR ?= MIRRORS/BIN-DATA

all: mirrors tests packaging

# requirements: aria2c
define call_aria2c
	aria2c --dir=$(1) --input-file=$(2) --continue --console-log-level=warn --auto-file-renaming=false --allow-overwrite=true --timeout=3 --user-agent="Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0"
endef
mirrors:
	$(call call_aria2c,$(BIN_LINUX_DIR)/,bin-linux.urls.list)
	$(call call_aria2c,$(BIN_LINUX_DIR)/,bin-mac.urls.list)
	$(call call_aria2c,$(BIN_WINDOWS_DIR)/,bin-windows.urls.list)
	$(call call_aria2c,$(BIN_DATA_DIR)/,bin-data.urls.list)

tests: shellcheck

shellcheck:
	for i in $$(find SCRIPTS/ -maxdepth 1 -type f); do \
		if grep '^#!/bin/bash' "$$i" >/dev/null; then \
		shellcheck "$$i" || exit 0 ; fi; done

packaging:
	cd PACKAGING/ && make
