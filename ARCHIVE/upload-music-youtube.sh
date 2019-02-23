#!/usr/bin/env python

"""
#Description: Upload an mp3 file to youtube, using cover.jpg as still video image.
cover.jpg needs to be in the same directory as the audio file you want to upload. Credentials are stored in ~/.config/youtubeuploadrc. Needs python-mutagen, python-gdata, youtube-upload, ppython-configparser libav/ffmpeg.
#License: http://opensource.org/licenses/MIT
#Source: https://github.com/nodiscc/scriptz

#Usage: youtube-music-upload.py /path/to/audio/file.mp3

__author__ = "nodiscc"
__license__ = "MIT"
__email__ = nodiscc@gmail.com

"""

#TODO: return errors with zenity (python-vsgui)
#TODO: check for avconv/ffmpeg and youtube-upload executables
#TODO: ability to upload FLAC and OGG files

from mutagen.id3 import ID3
import ConfigParser
import mimetypes
import os
from sys import argv
from subprocess import call
scriptname = argv[0]

#Parse config file
config_path = os.environ["HOME"] + '/.config/youtubeuploadrc'
#try: #TODO BUG: removed try/except because it always ends up going into the except loop, even though the config file is ok. For now, make sure it *really* is ok
config = ConfigParser.ConfigParser()
config.read(config_path)
yt_user = config.get('Youtube', 'Email', 0)
yt_passwd = config.get('Youtube', 'Password', 0)
#except: #Config file not ok, ask for user input
#    try:
#        print "Config file %s not readable or invalid!" % config_path
#        yt_user = raw_input('Enter your Youtube account email address: ')
#        yt_passwd = raw_input('Enter your Youtube account password: ')
#        config.add_section('Youtube')
#        config.set('Youtube','Email', yt_user)
#        config.set('Youtube','Password', yt_passwd)
#        print "Email and password stored in %s" % config_path
#    except ConfigParser.DuplicateSectionError:
#        overwrite = raw_input("Overwrite existing config? (Y/n) ")
#        if overwrite.lower() not in ['y','yes','']:
#            print "Exiting."
#            exit(1)
#        else:
#            os.remove(config_path)
#            config.read(config_path)
#            config.add_section('Youtube')
#            config.set('Youtube','Email', yt_user)
#            config.set('Youtube','Password', yt_passwd)
#            cfgfile = open(config_path) #BUG: doesn't work?
#            config.write(cfgfile)
#            cfgfile.close()
#            print "New config stored in %s" % config_path

print "Config found at %s" % config_path

#Check args
try:
    trackfile = argv[1]
except IndexError:
    print 'USAGE: %s file.mp3' % scriptname
    exit(1)

#Find track's ID3 tags
try:
    audio = ID3(trackfile)
except:
    print "File is not an mp3 file!"
    exit()
print "Track is %s" % trackfile
tracktitle = audio['TIT2'].text[0]
trackalbum = audio['TALB'].text[0]
trackartist = audio['TPE2'].text[0]
uploadname = trackartist + " - " + tracktitle

#Check presence of folder.jpg
cover = os.path.dirname(os.path.abspath(trackfile)) + "/folder.jpg"
if not os.access(cover, os.R_OK):
    print "Album art %s not found!" % cover
    exit(1)
print "Album art found at %s" % cover

#Convert to uploadable video
print "Encoding video......"
call(["avconv", "-loop", "1", "-i", cover, "-i", trackfile, "-tune", "stillimage", "-r", "1", "-s", "1280x720", "-c:a", "flac", "-shortest", "-v", "error", "out.ogv"])


#Upload video
print 'Trying to upload as user %s' % yt_user
print 'Video name: %s' % uploadname
print str(yt_user)
print str(yt_passwd)
upload_commandline = "youtube-upload --email=%s --password=%s --title=\"%s\" --category=Music out.ogv" % (yt_user, yt_passwd, uploadname)
call(upload_commandline, shell=True)

#Goodby temporary file
os.remove('out.ogv')