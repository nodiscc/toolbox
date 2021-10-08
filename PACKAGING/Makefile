all: yt_dlp

YT_DLP_VERSION=2021.09.25

yt_dlp:
	mkdir -p build/ dist/ yt-dlp/usr/local/bin
	cd build/ && \
	wget https://github.com/yt-dlp/yt-dlp/releases/download/2021.09.25/yt-dlp && \
	wget https://github.com/yt-dlp/yt-dlp/releases/download/2021.09.25/SHA2-512SUMS && \
	sha512sum --ignore-missing --check SHA2-512SUMS
	cp build/yt-dlp yt-dlp/usr/local/bin/
	chmod 0755 yt-dlp/usr/local/bin/yt-dlp
	sed -i "s/%%YT_DLP_VERSION%%/$(YT_DLP_VERSION)/g" yt-dlp/DEBIAN/control
	chmod 0755 yt-dlp/DEBIAN/
	dpkg-deb --build yt-dlp/
	mv -v yt-dlp.deb dist/yt-dlp_$(YT_DLP_VERSION)_amd64.deb

clean:
	rm -rf build/ dist/ yt-dlp/usr/local/bin/yt-dlp