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
.PHONY: cleanup-aria2
cleanup-aria2:
	find $(BIN_LINUX_DIR) $(BIN_WINDOWS_DIR) $(BIN_DATA_DIR) -type f \( -name "*.meta4" -o -name "*.aria2" \) -delete

.PHONY: mirrors
mirrors: cleanup-aria2
	$(call call_aria2c,$(BIN_LINUX_DIR)/,bin-linux.urls.list)
	$(call call_aria2c,$(BIN_WINDOWS_DIR)/,bin-windows.urls.list)
	$(call call_aria2c,$(BIN_DATA_DIR)/,bin-data.urls.list)

tests: test-comments test-shellcheck test-ansible-lint test-pylint

test-shellcheck:
	for i in $$(find SCRIPTS/ -maxdepth 1 -type f); do \
		if grep '^#!/bin/bash' "$$i" >/dev/null; then \
		shellcheck "$$i"; fi; done

test-pylint:
	python3 -m venv .venv
	.venv/bin/pip3 install wheel
	.venv/bin/pip3 install pylint==4.0.5 secretstorage==3.5.0 requests==2.33.1 caldav==3.2.0 icalendar==7.0.3 tqdm==4.67.3 send2trash==2.1.0 colorama==0.4.6 pyyaml==6.0.3 git+https://github.com/shaarli/python-shaarli-client@master
	.venv/bin/pylint --disable fixme,line-too-long,too-many-locals,consider-using-f-string,invalid-name --fail-under 8 --fail-on E,W \
		SCRIPTS/dashboard \
		SCRIPTS/file-sorter.py \
		SCRIPTS/gitea-issues

test-comments:
	for file in SCRIPTS/*; do \
	echo "Checking for description string in $$file"; \
	filetype=$$(file --brief --mime-type "$$file") && \
	if [[ "$$filetype" == "text/x-shellscript" ]]; then grep -q '^# Description:' "$$file" || exit 1; \
	elif [[ "$$filetype" == "text/x-script.python" ]]; then grep -q '^Description:' "$$file" || exit 1; \
	else true; \
	fi; \
	done

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
