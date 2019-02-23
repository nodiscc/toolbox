#!/bin/bash
#Description: lists Debian packages that have priority required or important
aptitude search -F'%p' ~prequired ~pimportant
