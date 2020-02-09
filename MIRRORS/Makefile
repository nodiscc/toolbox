#!/usr/bin/env make

all: download_isos download_binaries download_data download_tumblr download_wikia

#####################################################

download_isos:
	cd BIN-ISO/ && ./distrib-dl debian centos kali tails proxmox pfsense androidx86

download_binaries:
	wget --timestamping --no-verbose --show-progress --content-disposition --directory-prefix=BIN-LINUX/ --input-file=bin-linux.urls.list
	wget --timestamping --no-verbose --show-progress --content-disposition --directory-prefix=BIN-MAC/ --input-file=bin-mac.urls.list
	wget --timestamping --no-verbose --show-progress --content-disposition --directory-prefix=BIN-WINDOWS/ --input-file=bin-windows.urls.list

download_data:
	wget --timestamping --no-verbose --show-progress --content-disposition --directory-prefix=BIN-DATA/ --input-file=bin-data.urls.list

download_tumblr:
	cd TUMBLR/ && python ../GITHUB/tumblr_backup/tumblr_backup.py onethingwell.org

download_wikia:
	$(WGET) -P WIKIS/ https://s3.amazonaws.com/wikia_xml_dumps/e/el/elderscrolls_pages_current.xml.7z # http://elderscrolls.wikia.com/wiki/Special:Statistics
