#!/usr/bin/env make

all: mirrors_short

mirrors_short: mirror_git git_stat downloads_dbu download_github_stars downloads_linux downloads_windows downloads_macos downloads_iso

mirrors_long: mirrors_short mirror_git_long git_stat download_data download_maps

mirrors_all: mirrors_long download_tumblr download_wikia download_icons download_mediawiki

#####################################################

optimize:
	git submodule foreach git gc --aggressive

mirror_git:
	mr -c mrconfig update

git_stat:
	mr -c mrconfig stat
	git status

downloads_dbu:
	cd GIT/dbu && make download_extra clean

GITHUB_STARS_BACKUP_USER := "nodiscc"
download_github_stars:
	cd GIT/github-stars-backup/ && ./github-stars-backup $(GITHUB_STARS_BACKUP_USER)
	-cd GIT/github-stars-backup/ && git add . && git commit -m "update" && git push

DISTRIB_DL_DISTRIBUTIONS := "debian centos kali tails proxmox pfsense"
downloads_iso:
	cd BIN-ISO/ && ./distrib-dl $(DISTRIB_DL_DISTRIBUTIONS)

WGET := wget -N -nv --show-progress
downloads_linux:
	$(WGET) --content-disposition -P BIN-LINUX/ 'https://download.mozilla.org/?product=firefox-nightly-latest-ssl&os=linux64&lang=en-US'
	$(WGET) -P BIN-LINUX/ https://deb.debian.org/debian/pool/main/r/retext/retext_7.0.4-1_all.deb # https://github.com/retext-project/retext
	$(WGET) -P BIN-LINUX/ https://download.opensuse.org/repositories/home:/jgeboski/Debian_9.0/amd64/purple-facebook_20190113-0.9.6-0250907-166_amd64.deb
	$(WGET) -P BIN-LINUX/ https://download.opensuse.org/repositories/home:/RockHopper/Debian_9.0/amd64/shuriken_0.5.2-2stretch1_amd64.deb # https://rock-hopper.github.io/shuriken/ (blocks wget user-agent)
	$(WGET) -P BIN-LINUX/ https://download.sublimetext.com/sublime_text_3_build_3176_x64.tar.bz2 # https://www.sublimetext.com/3
	$(WGET) -P BIN-LINUX/ https://downloads.lwks.com/lwks-12.6.0-amd64.deb # https://www.lwks.com/ (non-free)
	$(WGET) -P BIN-LINUX/ https://downloads.tuxfamily.org/godotengine/2.1.3/Godot_v2.1.3-stable_x11.64.zip
	$(WGET) -P BIN-LINUX/ https://github.com/artfwo/andes/releases/download/v0.1/Andes1-0.1-linux-x86_64.tar.gz
	$(WGET) -P BIN-LINUX/ https://github.com/BurntSushi/xsv/releases/download/0.10.3/xsv-0.10.3-i686-unknown-linux-musl.tar.gz
	$(WGET) -P BIN-LINUX/ https://github.com/Dynalon/mdwiki/releases/download/0.6.2/mdwiki-0.6.2.zip
	$(WGET) -P BIN-LINUX/ https://github.com/dyson/indicator-workspaces/releases/download/v0.5/indicator-workspaces_0.5_all.deb # https://github.com/dyson/indicator-workspaces
	$(WGET) -P BIN-LINUX/ https://github.com/feross/webtorrent-desktop/releases/download/v0.16.0/webtorrent-desktop_0.16.0-1_amd64.deb
	$(WGET) -P BIN-LINUX/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-linux-1.0.5.zip
	$(WGET) -P BIN-LINUX/ https://github.com/github/hub/releases/download/v2.3.0-pre10/hub-linux-amd64-2.3.0-pre10.tgz
	$(WGET) -P BIN-LINUX/ https://github.com/jliljebl/flowblade/releases/download/v2.0/flowblade-2.0.0-1_all.deb
	$(WGET) -P BIN-LINUX/ https://github.com/junegunn/fzf-bin/releases/download/0.15.9/fzf-0.15.9-linux_amd64.tgz
	$(WGET) -P BIN-LINUX/ https://github.com/klembot/twinejs/releases/download/2.2.1/twine_2.2.1_linux64.zip
	$(WGET) -P BIN-LINUX/ https://github.com/kmkolasinski/AwesomeBump/releases/download/Linuxv5.0/AwesomeBumpV5.Bin64Linux.tar.gz
	$(WGET) -P BIN-LINUX/ https://github.com/mifi/lossless-cut/releases/download/v2.1.0/LosslessCut-linux-x64.zip
	$(WGET) -P BIN-LINUX/ https://github.com/mltframework/shotcut/releases/download/v17.09/shotcut-linux-x86_64-170904.tar.bz2
	$(WGET) -P BIN-LINUX/ https://github.com/pbek/QOwnNotes/releases/download/linux-b3572-073533/QOwnNotes-18.05.0.deb
	$(WGET) -P BIN-LINUX/ https://github.com/vrana/adminer/releases/download/v4.7.2/adminer-4.7.2.php
	$(WGET) -P BIN-LINUX/ https://mirror03.popcorntime.sh/repo/build/Popcorn-Time-0.3.10-Linux-64.tar.xz
	$(WGET) -P BIN-LINUX/ https://packagecontrol.io/Package%20Control.sublime-package
	$(WGET) -P BIN-LINUX/ https://s3.amazonaws.com/Minecraft.Download/versions/1.11.2/minecraft_server.1.11.2.jar
	$(WGET) -P BIN-LINUX/ https://yt-dl.org/downloads/latest/youtube-dl
	#$(WGET) -P BIN-LINUX/ http://ppa.launchpad.net/mank319/go-for-it/ubuntu/pool/main/g/go-for-it/go-for-it_1.4.7-0~142~ubuntu16.10.1_amd64.deb # https://github.com/mank319/Go-For-It (see PPA for other files)
	#$(WGET) -P BIN-LINUX/ http://ppa.launchpad.net/mapmap/mapmap/ubuntu/pool/main/m/mapmap/mapmap_0.4.0-1~trusty~ppa1_amd64.deb # http://mapmap.info/ (see PPA for other files)
	#$(WGET) -P BIN-LINUX/ http://ppa.launchpad.net/tsbarnes/indicator-keylock/ubuntu/pool/main/i/indicator-keylock/indicator-keylock_3.0.2-0~ppa1_amd64.deb # https://launchpad.net/~tsbarnes/+archive/ubuntu/indicator-keylock (see PPA for other files)
	#$(WGET) -P BIN-LINUX/ http://www.qlcplus.org/downloads/4.11.0/qlcplus_4.11.0_amd64.deb # http://www.qlcplus.org/
	#$(WGET) -P BIN-LINUX/ http://www.worldpainter.net/files/worldpainter_2.4.1.deb
	#$(WGET) -P BIN-LINUX/ http://al.chemy.org/files/Alchemy-008.tar.gz
	#$(WGET) -P BIN-LINUX/ http://iographica.com/download/linux/IOGraph_v1_0_1.jar
	#$(WGET) -P BIN-LINUX/ http://ppa.launchpad.net/gottcode/gcppa/ubuntu/pool/main/k/kapow/kapow_1.5.5-0ppa1~zesty1_amd64.deb # https://gottcode.org/kapow/ (see PPA for other files)
	#$(WGET) -P BIN-LINUX/ https://az764295.vo.msecnd.net/stable/929bacba01ef658b873545e26034d1a8067445e9/code_1.18.1-1510857349_amd64.deb # https://code.visualstudio.com/ https://github.com/Microsoft/vscode
	#$(WGET) -P BIN-LINUX/ https://download.opensuse.org/repositories/home:/pbek:/QOwnNotes/Debian_9.0/amd64/qownnotes_18.02.0-1_amd64.deb # http://www.qownnotes.org/
	#$(WGET) -P BIN-LINUX/ https://github.com/brrd/Abricotine/releases/download/0.5.0/Abricotine-linux-ubuntu-debian-x64.deb # https://github.com/brrd/Abricotine
	#wget -N -nv --show-progress http://tiddlywiki.com/empty.html -O MIRRORS/BIN-LINUX/tiddlywiki-empty.html


downloads_macos:
	$(WGET)  -P BIN-MAC/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-macos-1.0.5.zip

downloads_windows:
	$(WGET) -P BIN-WINDOWS/ https://github.com/EionRobb/pidgin-opensteamworks/releases/download/1.6.1/libsteam-1.6.1.dll
	$(WGET) -P BIN-WINDOWS/ https://yt-dl.org/downloads/latest/youtube-dl.exe
	#$(WGET) -P BIN-WINDOWS/ http://23.98.147.40/uploads/MagicaVoxel-0.98.1-win-mac-beta.zip
	#$(WGET) -P BIN-WINDOWS/ http://download.wsusoffline.net/wsusoffline1092.zip
	#$(WGET) -P BIN-WINDOWS/ http://freealarmclocksoftware.com/FreeAlarmClockPortable.zip
	#$(WGET) -P BIN-WINDOWS/ http://www.world-machine.com/WM237_Basic.exe
	#$(WGET) -P BIN-WINDOWS/ https://fpdownload.macromedia.com/pub/flashplayer/updaters/27/flashplayer_27_sa.exe
	#$(WGET) -P BIN-WINDOWS/ https://github.com/brrd/Abricotine/releases/download/0.5.0/Abricotine-setup-win32-x64.exe
	#$(WGET) -P BIN-WINDOWS/ https://github.com/gbevin/SendMIDI/releases/download/1.0.5/sendmidi-windows-1.0.5.zip
	#$(WGET) -P BIN-WINDOWS/ https://github.com/mltframework/shotcut/releases/download/v17.09/shotcut-win64-170904.exe
	#$(WGET) -P BIN-WINDOWS/ https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.24.8/Npackd64-1.24.8.msi
	#$(WGET) -P BIN-WINDOWS/ https://github.com/tim-lebedkov/npackd-cpp/releases/download/version_1.24.8/NpackdCL64-1.24.8.msi

#####################################################################

mirror_git_long:
	mr -c mrconfig.extras update

TUMBLR_ARCHIVER_SOURCES := "onethingwell.org"
download_tumblr:
	cd TUMBLR/ && python ../GITHUB/tumblr_backup/tumblr_backup.py $(TUMBLR_ARCHIVER_SOURCES)

download_data:
	$(WGET) -P DATA/ https://public-dns.info/nameservers.csv

download_maps:
	$(WGET) -P DATA/ https://download.geofabrik.de/europe/france-latest.osm.pbf
	$(WGET) -P BIDATA/ https://download.kiwix.org/portable/wikipedia/kiwix-0.9+wikipedia_en_all_nopic_2017-08.zip # https://kiwix.org/ (blocks wget user-agent)
	$(WGET) -P DATA/ https://download.kiwix.org/portable/wikipedia/kiwix-0.9+wikipedia_fr_all_nopic_2018-03.zip # https://kiwix.org/ (blocks wget user-agent)



# Mirror mediawikis using https://github.com/Git-Mediawiki/Git-Mediawiki/
WIKI_MIRRORS := $(find "$$PWD/MIRRORS/WIKI/" -maxdepth 1 -mindepth 1 -type d)
MEDIAWIKI_ARCHIVER_GIT_OPTIONS := -c remote.origin.mediaImport="true" -c remote.origin.shallow="true"
download_mediawiki:
	for i in $(WIKI_MIRRORS); do cd "$$i"; git pull --depth=1; done # update already cloned mediawikis
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://wiki.archlinux.org/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://www.ekopedia.fr/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://en.wikiaudio.org
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.step-project.com/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.appropedia.org
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.sigidwiki.com/wiki
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://en.wikibooks.org/wiki
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://www.thomas-krenn.com/en/wiki
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.funtoo.org/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://www.freebsdwiki.net/ #CLOSING SOON!!
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://wiki.openstreetmap.org/wiki/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wikiindex.org/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.hydrogenaud.io/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.linuxquestions.org/wiki
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::http://wiki.linuxaudio.org/wiki/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://libregamewiki.org/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://fr.wikisource.org/wiki/
	#-cd WIKI/ && git $(MEDIAWIKI_ARCHIVER_GIT_OPTIONS) clone --depth=1 mediawiki::https://fr.wiktionary.org/wiki/

download_wikia:
	$(WGET) -P WIKIS/ https://s3.amazonaws.com/wikia_xml_dumps/e/el/elderscrolls_pages_current.xml.7z # http://elderscrolls.wikia.com/wiki/Special:Statistics


