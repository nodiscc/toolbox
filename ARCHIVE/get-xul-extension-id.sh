#!/bin/bash
#Description: Retrieve the extension id for a firefox addon from its install.rdf
#Source: http://kb.mozillazine.org/MozillaZine_Knowledge_Base:About
#License: CC-BY-SA

set -e

if unzip -qc "$1" install.rdf >/dev/null; then
	extension_id=$(unzip -qc "$1" install.rdf | xmlstarlet sel \
		-N rdf=http://www.w3.org/1999/02/22-rdf-syntax-ns# \
		-N em=http://www.mozilla.org/2004/em-rdf# \
		-t -v \
		"//rdf:Description[@about='urn:mozilla:install-manifest']/em:id")
	echo "$extension_id"
elif unzip -qc "$1" manifest.json >/dev/null; then
	extension_id=$(unzip -qc "$1" manifest.json | grep '"id"' | cut -d'"' -f4)
		if [[ "$extension_id" == "" ]]; then
			extension_id=$(unzip -qc "$1" manifest.json | grep '"name"' | cut -d'"' -f4)
		fi
	echo "$extension_id"
else
	exit 1
fi
