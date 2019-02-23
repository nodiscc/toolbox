#!/bin/bash
set -e
set -o nounset
all_unique_english_wikipedia_links=$(grep --only-matching -i --no-filename --extended-regexp \
	'wikipedia\:([^|#]*)*' wiki.archlinux.org/*.mw| cut -d ']' -f1 | \
	egrep -v '\:[a-z]*\:' | \
	sed 's/[wW]ikipedia\://g' | \
	sed 's/_/ /g'|  sort --unique) && \
echo "$$all_unique_english_wikipedia_links" >| archlinux-wikipedia-links.txt

#TODO [enh] alt. .zim downloads from http://wiki.kiwix.org/wiki/Content_in_all_languages
#TODO [enh] https://github.com/WikiTeam/wikiteam/wiki/Available-Backups
#TODO convert to netscape html bookmarks format with ../SCRIPTS/urllist.sh
#TODO archive pages with ../SCRIPTS/bookmarks-archiver.sh
#TODO [enh] generate html with pandoc -f mediawiki -t html $page.mw -o $page.html ....
# CSS: https://wiki.archlinux.org/load.php?debug=false&lang=en&modules=mediawiki.legacy.commonPrint,shared|mediawiki.skinning.content.externallinks|mediawiki.skinning.interface|skins.archlinux.styles|site&only=styles&skin=archlinux
# TDO https://developer.mozilla.org/en-US/Firefox/Headless_mode Firefox 55+
# Doc: see also https://github.com/lahwaacz/arch-wiki-docs/ (Python/pandoc)
