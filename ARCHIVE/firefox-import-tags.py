#!/usr/bin/python2
# - encoding: UTF-8 -
#Description: Import your bookmarks with tags into Firefox from Delicous (and maybe others)
#
# 1. Export delcious bookmarks into a html file
# 2. Import those bookmarks with Firefox' bookmark manager (will omit tags)
# 3. Run this script with following arguments:
#   1. arg: places.sqlite (database file containing bookmarks)
#           Found in your profile (~/.mozilla/firefox/<profile-name>/places.sqlite)
#           Better back it up and work on a copy
#   2. arg: Name of the folder which contains the just imported bookmarks;
#           After importing them with the bookmark manager,
#           put all bookmarks in a folder with a unique name
#   3. arg: Html file containing the bookmarks with tags;
#
# Example:
# ./ff_import_tags.py places.sqlite "delicious_import" delicious.html
#
# For more details on the db structure of Firefox:
# http://stackoverflow.com/questions/464516/firefox-bookmarks-sqlite-structure


import sys
import re
import codecs
import sqlite3

SQLITE_DB = sys.argv[1]
FOLDER = sys.argv[2]
EXPORT_HTML = sys.argv[3]

db = sqlite3.connect(SQLITE_DB)
c = db.cursor()
f = codecs.open(EXPORT_HTML, encoding='utf-8')

# Get parent_id of FOLDER
parent_id = c.execute("""SELECT id FROM moz_bookmarks WHERE type = 2 AND parent = 2 AND title = ?""", (FOLDER,)).fetchone()[0]

# get all bookmarks from FOLDER (no tags yet)
bookmarks = c.execute("""SELECT fk FROM moz_bookmarks WHERE type = 1 AND parent = ?""", (parent_id,)).fetchall()

for b_fk in bookmarks:
    # get url of bookmark to find it in the exported html
    url = c.execute("SELECT url FROM moz_places WHERE id = ?", b_fk).fetchone()[0]
    tags = None

    # get tags for this bookmark
    f.seek(0) # rewind to start of file
    for line in f:
        if url in line:
            match = re.search(r'TAGS="(.*?)"', line, re.UNICODE)
            if match:
                tags = match.group(1)
            else:
              print "Could not find tags for bookmark: %i - %s" % (b_fk[0], url)
            break
    else:
        print "Could not find bookmark: %i - %s" % (b_fk[0], url)
        continue

    if tags is None: continue

    tags = [tag for tag in re.split(',\s*|\s*', tags) if tag]

    for tag in tags:
        # check if tag exists
        t_id = c.execute("SELECT id FROM moz_bookmarks WHERE parent = 4 AND type = 2 AND title = ?", (tag,)).fetchone()

        if not t_id: # if not, create tag and get id
            t_id = c.execute("INSERT INTO moz_bookmarks(type, parent, title) VALUES(2, 4, ?)", (tag,)).lastrowid
            db.commit()
        else:
            t_id = t_id[0] # if it does, use existing tag id

        # insert tag link
        c.execute("INSERT INTO moz_bookmarks(type, fk, parent) VALUES(1, ?, ?)", (b_fk[0], t_id))
        db.commit()
        print "tagged bookmark '%s' with tag '%s' (fk: %i)" % (url, tag, b_fk[0])

f.close()
db.commit()
db.close()
