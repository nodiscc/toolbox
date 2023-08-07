#!/usr/bin/env make
SHELL := '/bin/bash'
LANG = C

test-ansible-lint:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip3 install wheel && \
	pip3 install isort ansible-lint==6.17.2 ansible==8.0.0 && \
	ansible-galaxy collection install git+https://gitlab.com/nodiscc/xsrv.git && \
	ansible-lint -v -x fqcn[action-core],fqcn[action],name[casing],yaml[truthy],schema[meta],yaml[line-length],var-naming[no-role-prefix] roles/*
