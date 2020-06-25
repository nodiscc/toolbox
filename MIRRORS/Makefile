#!/usr/bin/env make

all: download_isos download_binaries download_data

full: all download_tumblr download_wikia

#####################################################

download_isos:
	cd BIN-ISO/ && ./distrib-dl all

WGET = wget --no-clobber --show-progress --content-disposition --tries 1 --timeout 3
download_binaries:
	$(WGET) --directory-prefix=BIN-LINUX/ --input-file=bin-linux.urls.list
	$(WGET) --directory-prefix=BIN-MAC/ --input-file=bin-mac.urls.list
	$(WGET) --directory-prefix=BIN-WINDOWS/ --input-file=bin-windows.urls.list

download_data:
	$(WGET) --directory-prefix=BIN-DATA/ --input-file=bin-data.urls.list

download_tumblr:
	cd TUMBLR/ && python ../GITHUB/tumblr_backup/tumblr_backup.py onethingwell.org

download_wikia:
	$(WGET) -P WIKIS/ https://s3.amazonaws.com/wikia_xml_dumps/e/el/elderscrolls_pages_current.xml.7z # http://elderscrolls.wikia.com/wiki/Special:Statistics
