all: yt_dlp bleachbit_cleanerml

YT_DLP_VERSION=2021.09.25
CLEANERML_VERSION=5bc2961
CLEANERML_PACKAGE_VERSION="0.0.1~git0"

yt_dlp:
	rm -rf build/
	mkdir -p build/ dist/ yt-dlp/usr/local/bin
	cd build/ && \
	wget https://github.com/yt-dlp/yt-dlp/releases/download/$(YT_DLP_VERSION)/yt-dlp && \
	wget https://github.com/yt-dlp/yt-dlp/releases/download/$(YT_DLP_VERSION)/SHA2-512SUMS && \
	sha512sum --ignore-missing --check SHA2-512SUMS
	cp -v build/yt-dlp yt-dlp/usr/local/bin/
	chmod -v 0755 yt-dlp/usr/local/bin/yt-dlp
	sed -i "s/%%YT_DLP_VERSION%%/$(YT_DLP_VERSION)/g" yt-dlp/DEBIAN/control
	chmod -v 0755 yt-dlp/DEBIAN/
	dpkg-deb --build yt-dlp/
	mv -v yt-dlp.deb dist/yt-dlp_$(YT_DLP_VERSION)_amd64.deb

bleachbit_cleanerml:
	rm -rf build/
	mkdir -p build/ dist/ bleachbit-cleanerml/usr/share/bleachbit/cleaners/
	cd build/ && \
	wget --continue --no-verbose --show-progress https://github.com/az0/cleanerml/archive/$(CLEANERML_VERSION).zip && \
	unzip -q $(CLEANERML_VERSION).zip && \
	mv -v cleanerml-$(CLEANERML_VERSION)*/release/*xml ../bleachbit-cleanerml/usr/share/bleachbit/cleaners/
	sed -i "s/%%CLEANERML_VERSION%%/$(CLEANERML_PACKAGE_VERSION)+$(CLEANERML_VERSION)/g" bleachbit-cleanerml/DEBIAN/control
	chmod -v 0755 bleachbit-cleanerml/DEBIAN/ bleachbit-cleanerml/DEBIAN/preinst bleachbit-cleanerml/DEBIAN/postrm
	dpkg-deb --build bleachbit-cleanerml/
	mv -v bleachbit-cleanerml.deb dist/bleachbit-cleanerml_$(CLEANERML_PACKAGE_VERSION)+$(CLEANERML_VERSION)_all.deb

clean:
	rm -rf build/ dist/ yt-dlp/usr/local/bin/yt-dlp bleachbit-cleanerml/usr/share/bleachbit/cleaners/*xml
