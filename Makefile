#!/usr/bin/env make
SHELL := '/bin/bash'

all: mirrors tests

mirrors:
	cd MIRRORS/ && make

tests:
	for i in $$(find SCRIPTS/ -maxdepth 1 -type f); do \
		if grep '^#!/bin/bash' "$$i" >/dev/null; then \
		shellcheck "$$i" || exit 1 ; fi; done
