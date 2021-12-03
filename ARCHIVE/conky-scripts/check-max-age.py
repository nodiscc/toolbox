#!/usr/bin/python3
'''Checks last modification time of a file (PATH)
   returns an 'OK' symbol if last modification is more recent than MAX_AGE_IN_SECONDS
   returns an 'ERROR' symbol if it is older
   useful to check correct execution of recurrent scheduled tasks
   USAGE: check-max-age.py PATH MAX_AGE_IN_SECONDS'''

import sys
import os
import time

def get_status(path, max_age):
    '''get the status of the file (ok: more recent than threshold, error: older or file absent)'''
    if not os.path.isfile(path):
        status = 'error'
        error = 'file absent'
        age = None
    else:
        modtime = os.path.getmtime(path)
        curtime = int (time.time())
        age = curtime - modtime
        if age > int(max_age):
            status = 'error'
            error = None
        else:
            status = 'ok'
            error = None
    return status, age, error

def seconds_to_dhm(time_in_seconds):
    '''convert a unix timestamp to the DDd HHh MMm SSs format'''
    day = time_in_seconds // (24 * 3600)
    time_in_seconds = time_in_seconds % (24 * 3600)
    hour = time_in_seconds // 3600
    time_in_seconds %= 3600
    minutes = time_in_seconds // 60
    time_in_seconds %= 60
    seconds = time_in_seconds
    dhm = '{}d {}h {}m {}s'.format(
        int(day), int(hour), int(minutes), int(seconds))
    return dhm

if __name__ == "__main__":
    path = sys.argv[1]
    max_age = sys.argv[2]
    status, age, error = get_status(path, max_age)
    if error is None:
        reason = seconds_to_dhm(age)
    else:
        reason = error
    default_font='${font Roboto:pixelsize=12}'
    icon = '${font Liberation:pixelsize=12}${color2}✘${color}' if status == 'error' else '${font Liberation:pixelsize=12}${color3}✔${color}'
    print(default_font + os.path.basename(path) + ' ' + icon + ' ' + default_font + reason)
