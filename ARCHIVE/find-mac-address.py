#!/usr/bin/python
#Description: prints vendor for each given mac address
# Author: Yuri, yurisk@yurisk.info,06.2010
import sys
import re
#This function removes in MACs column or dot and returns MAC as a sequence of HEX chars
def dotreplace(matchobj):
       if matchobj.group(0) == '.':
            return ''
       elif  matchobj.group(0) == ':':
            return ''
#open file with NAC addresses and vendors database,it has form xxxx <VEndor>
macs=open('mac-database.txt','r')
macs_lines=macs.readlines()
#Read from stdinput
data = sys.stdin.readlines()
for ppp in data:
       popa=re.search('.*([a-f0-9]{4}\.[a-f0-9]{4}\.[a-f0-9]{4}).*',ppp,re.IGNORECASE)
       if popa:
             newpopa=re.sub('\.', dotreplace,popa.group(1))[0:6]
             newpopa_re=re.compile(newpopa,re.IGNORECASE)
             for mac_db in macs_lines:
                 vendor=re.search(newpopa_re,mac_db)
                 if vendor:
                    print ppp.strip(),mac_db[7:],
       popahp=re.search('.*([a-f0-9]{6}\-[a-f0-9]{6}).*',ppp,re.IGNORECASE)
       if popahp:
             newpopa=re.sub('\.', dotreplace,popahp.group(1))[0:6]
             newpopa_re=re.compile(newpopa,re.IGNORECASE)
             for mac_db in macs_lines:
                 vendor=re.search(newpopa_re,mac_db)
                 if vendor:
                    print ppp.strip(),mac_db[7:],
       popalinux = re.search('.*([a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}:[a-f0-9]{2}).*',ppp,re.IGNORECASE)
       if popalinux:
             newpopalinux=re.sub(':',dotreplace,popalinux.group(1))[0:6]
             newpopalinux_re=re.compile(newpopalinux,re.IGNORECASE)
             for mac_db in macs_lines:
                 vendor=re.search(newpopalinux_re,mac_db)
                 if vendor:
                    print ppp.strip(),mac_db[7:],
