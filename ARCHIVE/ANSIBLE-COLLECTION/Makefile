#!/usr/bin/env make
SHELL := '/bin/bash'
LANG = C

test-ansible-lint:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip3 install wheel && \
	pip3 install isort ansible-lint==6.21.1 ansible==8.5.0 && \
	ansible-galaxy collection install git+https://gitlab.com/nodiscc/xsrv.git && \
	ansible-lint -v -x fqcn[action-core],fqcn[action],name[casing],yaml[truthy],schema[meta],yaml[line-length],var-naming[no-role-prefix] roles/*

# manual: udpate auto-generated documentation
doc: doc_tags doc_roles_list

doc_tags:
	@for i in roles/*; do \
		echo $$i; \
		tags_list=$$(grep '^# @' $$i/meta/main.yml); \
		echo -e "\`\`\`\n$$tags_list\n\`\`\`" | sed 's/# @tag //g'> tags.tmp.md && \
		awk ' \
			BEGIN { p=1} \
			/^<!--BEGIN TAGS LIST-->/ {print;system("cat tags.tmp.md");p=0} \
			/^<!--END TAGS LIST-->/ {p=1} \
			p' $$i/README.md >> README.tmp.md && \
		rm tags.tmp.md && \
		mv README.tmp.md $$i/README.md; \
	done

doc_roles_list:
	@roles_list_md=$$(for i in roles/*/meta/main.yml; do \
		name=$$(grep "role_name: " "$$i" | awk -F': ' '{print $$2}'); \
		description=$$(grep "description: " "$$i" | awk -F': ' '{print $$2}' | sed 's/"//g'); \
		echo "- [$$name](roles/$$name) - $$description"; \
		done) && \
		echo "$$roles_list_md" >| roles-list.tmp.md && \
		awk ' \
		BEGIN {p=1} \
		/^<!--BEGIN ROLES LIST-->/ {print;system("cat roles-list.tmp.md | sort --version-sort");p=0} \
		/^<!--END ROLES LIST-->/ {p=1} \
		p' README.md >> README.tmp.md && \
		mv README.tmp.md README.md && \
		rm roles-list.tmp.md