all: yt_dlp bleachbit_cleanerml lutris user.js tartube

YT_DLP_VERSION=2025.01.26
CLEANERML_VERSION=5bc2961
CLEANERML_PACKAGE_VERSION=0.0.1~git0
PIDGIN_OPENSTEAMWORKS_VERSION=1.7
LUTRIS_VERSION=0.5.19
USERJS_VERSION=0.10.0
USERJS_PACKAGE_VERSION=$(USERJS_VERSION)-1
TARTUBE_VERSION=2.5.100

yt_dlp:
	rm -rf build/
	mkdir -p build/ dist/ yt-dlp/usr/bin yt-dlp/usr/share/man/man1/ yt-dlp/usr/share/bash-completion/completions/
	cd build/ && \
	wget --continue --no-verbose https://github.com/yt-dlp/yt-dlp/releases/download/$(YT_DLP_VERSION)/yt-dlp.tar.gz && \
	wget --continue --no-verbose https://github.com/yt-dlp/yt-dlp/releases/download/$(YT_DLP_VERSION)/SHA2-512SUMS && \
	sha512sum --ignore-missing --check SHA2-512SUMS && \
	tar -zxvf yt-dlp.tar.gz
	cp -v build/yt-dlp/yt-dlp yt-dlp/usr/bin/
	cp -v build/yt-dlp/yt-dlp.1 yt-dlp/usr/share/man/man1/
	cp -v build/yt-dlp/completions/bash/yt-dlp yt-dlp/usr/share/bash-completion/completions/
	chmod -v 0755 yt-dlp/usr/bin/yt-dlp
	sed -i "s/%%YT_DLP_VERSION%%/$(YT_DLP_VERSION)/g" yt-dlp/DEBIAN/control
	chmod -v 0755 yt-dlp/DEBIAN/
	dpkg-deb --build yt-dlp/
	mv -v yt-dlp.deb dist/yt-dlp_$(YT_DLP_VERSION)_amd64.deb

bleachbit_cleanerml:
	rm -rf build/
	mkdir -p build/ dist/ bleachbit-cleanerml/usr/share/bleachbit/cleaners/
	cd build/ && \
	wget --continue --no-verbose https://github.com/az0/cleanerml/archive/$(CLEANERML_VERSION).zip && \
	unzip -q $(CLEANERML_VERSION).zip && \
	mv -v cleanerml-$(CLEANERML_VERSION)*/release/*xml ../bleachbit-cleanerml/usr/share/bleachbit/cleaners/
	sed -i "s/%%CLEANERML_VERSION%%/$(CLEANERML_PACKAGE_VERSION)+$(CLEANERML_VERSION)/g" bleachbit-cleanerml/DEBIAN/control
	chmod -v 0755 bleachbit-cleanerml/DEBIAN/ bleachbit-cleanerml/DEBIAN/preinst bleachbit-cleanerml/DEBIAN/postrm
	dpkg-deb --build bleachbit-cleanerml/
	mv -v bleachbit-cleanerml.deb dist/bleachbit-cleanerml_$(CLEANERML_PACKAGE_VERSION)+$(CLEANERML_VERSION)_all.deb

# disabled, plugin broken (https://github.com/EionRobb/pidgin-opensteamworks/issues/206)
# pidgin_opensteamworks:
# 	rm -rf build/
# 	mkdir -p build/ dist/
# 	cd build/ && \
# 	wget --continue --no-verbose https://github.com/EionRobb/pidgin-opensteamworks/archive/refs/tags/$(PIDGIN_OPENSTEAMWORKS_VERSION).zip && \
# 	unzip -q $(PIDGIN_OPENSTEAMWORKS_VERSION).zip
# 	echo "Steam plugin for Pidgin/libpurple" > build/pidgin-opensteamworks-$(PIDGIN_OPENSTEAMWORKS_VERSION)/steam-mobile/description-pak
# 	cd build/pidgin-opensteamworks-$(PIDGIN_OPENSTEAMWORKS_VERSION)/steam-mobile/ && \
# 	checkinstall --pkgname=pidgin-opensteamworks --arch=amd64 --pkglicense=GPL-3.0 \
# 		--pkgsource https://github.com/EionRobb/pidgin-opensteamworks \
# 		--pkgversion $(PIDGIN_OPENSTEAMWORKS_VERSION) \
# 		--maintainer='nodiscc <nodiscc@gmail.com>' \
# 		--nodoc \
# 		--default \
# 		--install=no \
# 		--showinstall \
# 		--requires="libpurple0,libglib2.0-0,libjson-glib-1.0-0,libnss3"
# 	mv -v build/pidgin-opensteamworks-$(PIDGIN_OPENSTEAMWORKS_VERSION)/steam-mobile/pidgin-opensteamworks_$(PIDGIN_OPENSTEAMWORKS_VERSION)-1_amd64.deb dist/

lutris:
	mkdir -p dist/
	wget --continue --no-verbose --directory-prefix=dist/ https://github.com/lutris/lutris/releases/download/v$(LUTRIS_VERSION)/lutris_$(LUTRIS_VERSION)_all.deb

.PHONY: user.js
user.js:
	mkdir -pv build/ dist/
	wget --continue --no-verbose https://github.com/nodiscc/user.js/archive/$(USERJS_VERSION).zip -O build/user.js-$(USERJS_VERSION).zip
	unzip build/user.js-$(USERJS_VERSION).zip -d build/
	mkdir -pv user.js/usr/share/user.js/ user.js/usr/share/doc/user.js/ user.js/usr/lib/firefox-esr/distribution/
	cd build/user.js-$(USERJS_VERSION)/ && make systemwide_user.js
	cp -v build/user.js-$(USERJS_VERSION)/user.js user.js/usr/share/user.js/user.js
	cp -v build/user.js-$(USERJS_VERSION)/systemwide_user.js user.js/usr/share/user.js/systemwide_user.js
	cp -v build/user.js-$(USERJS_VERSION)/policies.json user.js/usr/lib/firefox-esr/distribution/policies.json
	cp -v build/user.js-$(USERJS_VERSION)/LICENSE user.js/usr/share/doc/user.js/LICENCE
	cp -v build/user.js-$(USERJS_VERSION)/README.md user.js/usr/share/doc/user.js/README.md
	sed -i "s/%%USERJS_VERSION%%/$(USERJS_VERSION)/g" user.js/DEBIAN/control
	chmod -v 0755 user.js/DEBIAN/ user.js/DEBIAN/postinst user.js/DEBIAN/prerm
	dpkg-deb --build user.js/
	mv -v user.js.deb dist/user.js_$(USERJS_PACKAGE_VERSION)_all.deb

.PHONY: tartube
tartube:
	wget -O dist/python3-tartube_$(TARTUBE_VERSION).deb https://github.com/axcore/tartube/releases/download/v$(TARTUBE_VERSION)/python3-tartube_$(TARTUBE_VERSION).deb

clean:
	rm -rf build/ dist/ yt-dlp/usr/ bleachbit-cleanerml/usr/share/bleachbit/cleaners/*xml user.js/usr/share/
