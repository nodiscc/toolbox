all: yt_dlp bleachbit_cleanerml lutris user.js tartube

YT_DLP_VERSION=2026.03.03
CLEANERML_VERSION=5bc2961
CLEANERML_PACKAGE_VERSION=0.0.1~git0
PIDGIN_OPENSTEAMWORKS_VERSION=1.7
LUTRIS_VERSION=0.5.22
USERJS_VERSION=0.13.0
USERJS_PACKAGE_VERSION=$(USERJS_VERSION)-1
TARTUBE_VERSION=2.5.197

.PHONY: yt_dlp
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

.PHONY: bleachbit_cleanerml
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

.PHONY: lutris
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
	rm -rf build/ dist/ yt-dlp/usr/ bleachbit-cleanerml/usr/share/bleachbit/cleaners/*xml user.js/usr/share/ tipsy/usr/

##### MANUAL BUILD TASKS, NOT RUN BY CI/MAKE ALL #####
TIPSY_VERSION=863e3dc424b28631c7de24da3d9ff572797a1792
TIPSY_PACKAGE_VERSION=0.0.1-git$(TIPSY_VERSION)
.PHONY: tipsy
tipsy:
	rm -rf build/
	mkdir -pv build/ build/tipsy-models/ dist/
	wget --continue --no-verbose https://github.com/nkanaev/tipsy/archive/$(TIPSY_VERSION).zip -O build/tipsy-$(TIPSY_VERSION).zip
	unzip build/tipsy-$(TIPSY_VERSION).zip -d build/
	wget --continue --no-verbose https://models.spriters-resource.com/media/assets/284/287322.zip?updated=1755497211 -O build/tipsy-models/squall.zip
	unzip build/tipsy-models/squall.zip -d build/tipsy-models/squall
	wget --continue --no-verbose https://models.spriters-resource.com/media/assets/302/305648.zip?updated=1755501652 -O build/tipsy-models/hex-navy.zip
	unzip build/tipsy-models/hex-navy.zip -d build/tipsy-models/hex-navy
	
	
	
	mkdir -pv tipsy/usr/bin/ tipsy/usr/share/tipsy/models
	cd build/tipsy-$(TIPSY_VERSION)/ && make tipsy
	cp -v build/tipsy-863e3dc424b28631c7de24da3d9ff572797a1792/tipsy tipsy/usr/bin/tipsy
	cp -rv build/tipsy-models/squall tipsy/usr/share/tipsy/models/
	cp -rv build/tipsy-models/hex-navy tipsy/usr/share/tipsy/models/
	sed -i "s/%%TIPSY_PACKAGE_VERSION%%/$(TIPSY_PACKAGE_VERSION)/g" tipsy/DEBIAN/control
	chmod -v 0755 tipsy/DEBIAN/
	dpkg-deb --build tipsy/
	mv -v tipsy.deb dist/tipsy_$(TIPSY_PACKAGE_VERSION)_all.deb
