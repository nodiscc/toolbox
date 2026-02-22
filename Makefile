#!/usr/bin/env make
SHELL := /bin/bash
LANG = C
BIN_LINUX_DIR ?= MIRRORS/BIN-LINUX
BIN_WINDOWS_DIR ?= MIRRORS/BIN-WINDOWS
BIN_DATA_DIR ?= MIRRORS/BIN-DATA

all: mirrors tests packaging

# requirements: aria2c
define call_aria2c
	aria2c --dir=$(1) --input-file=$(2) --continue --allow-overwrite=false --console-log-level=warn --auto-file-renaming=false --max-tries=3 --retry-wait=1 --timeout=3 --user-agent="Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0"
endef
.PHONY: mirrors
mirrors:
	$(call call_aria2c,$(BIN_LINUX_DIR)/,bin-linux.urls.list)
	$(call call_aria2c,$(BIN_WINDOWS_DIR)/,bin-windows.urls.list)
	$(call call_aria2c,$(BIN_DATA_DIR)/,bin-data.urls.list)

tests: test-shellcheck test-ansible-lint test-pylint

test-shellcheck:
	for i in $$(find SCRIPTS/ -maxdepth 1 -type f); do \
		if grep '^#!/bin/bash' "$$i" >/dev/null; then \
		shellcheck "$$i"; fi; done

test-pylint:
	python3 -m venv .venv
	.venv/bin/pip3 install wheel
	.venv/bin/pip3 install pylint secretstorage requests caldav icalendar tqdm send2trash colorama pyyaml
	.venv/bin/pylint --disable fixme,line-too-long,too-many-locals,consider-using-f-string,invalid-name --fail-under 8 --fail-on E,W SCRIPTS/dashboard SCRIPTS/file-sorter.py

test-ansible-lint:
	cd ARCHIVE/ANSIBLE-COLLECTION/ && make

packaging:
	cd PACKAGING/ && make

clean:
	cd ARCHIVE/ANSIBLE-COLLECTION/ && make clean
	rm -rf .venv/

update-mirrors:
	git add bin*.urls.list
	git commit -m "update mirrors"
