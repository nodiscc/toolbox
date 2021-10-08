#!/usr/bin/env make
SHELL := '/bin/bash'

all: mirrors tests packaging

mirrors:
	cd MIRRORS/ && make

tests: shellcheck

# non-blocking, warning only
shellcheck:
	for i in $$(find SCRIPTS/ -maxdepth 1 -type f); do \
		if grep '^#!/bin/bash' "$$i" >/dev/null; then \
		shellcheck "$$i" || exit 0 ; fi; done

packaging:
	cd PACKAGING/ && make