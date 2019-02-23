#!/usr/bin/python
# -*- coding: utf-8 -*-

"""
#Description: Fabric script to deploy Conky configuration.
"""
__author__ = "Ariel Gerardo Rios"

import os
from fabric.api import *

CONKY_DIR = "/etc/conky"
CONKY_CONF = "conky.conf"
CONKY_BIN = "/usr/bin/conky"
CONF_PATH = os.path.join(CONKY_DIR, CONKY_CONF)
LOCAL_DIR = os.path.realpath(os.path.dirname(__file__))
LOCAL_PATH = os.path.join(LOCAL_DIR, CONKY_CONF)

def delete():
    """Check if configuration file exists and delete it."""
    if os.path.exists(CONF_PATH):
        local("rm %s" % CONF_PATH)

def install():
    """Overwrite the existent configuration."""
    delete()
    link()

def link():
    """Link configuration file to versioned one."""
    local("ln -s %s %s" % (LOCAL_PATH, CONF_PATH))
    with settings(warn_only=True):
        local("/usr/bin/killall conky", capture=True)
    print "Now run: /usr/bin/nohup %s -c %s > /dev/null" % (CONKY_BIN, CONF_PATH)

