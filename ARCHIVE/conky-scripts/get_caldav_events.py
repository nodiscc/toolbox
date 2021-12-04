#!/usr/bin/env python3
# List tasks/Vcaldav_todos from a calDAV server
# requirements: secretstorage, caldav
# requires a running Freedesktop SecretStorage (gnome-keyring, keepassxc...) instance
# https://github.com/python-caldav/caldav
# https://github.com/python-caldav/caldav/blob/master/examples/basic_usage_examples.py
# https://secretstorage.readthedocs.io/en/latest/collection.html
# https://secretstorage.readthedocs.io/en/latest/item.html
# https://secretstorage.readthedocs.io/en/latest/index.html
from datetime import datetime, date
import sys
import caldav
import secretstorage
from contextlib import closing

# set this to False to ignore self-signed certificate warnings
caldav_ssl_verify_cert=True

# get credentials from freedesktop secretstorage
with closing(secretstorage.dbus_init()) as conn:
    collection = secretstorage.get_default_collection(conn)
    items = collection.search_items({'application': 'get_caldav_events.py'})
    try:
        item = next(items)
    except StopIteration:
        print('No credentials found. Please provide, URL, username and password:')
        caldav_url = input('Enter principal calDAV URL: ')
        username = input('Enter username: ')
        password = input('Enter password: ')
        collection.create_item ('CalDAV credentials (get_caldav_events.py)', {'application': 'get_caldav_events.py', 'username': username, 'caldav_url': caldav_url}, password)
        print('Credentials stored in secret storage.')
    username = item.get_attributes()['username']
    caldav_url = item.get_attributes()['caldav_url']
    password = item.get_secret()

client = caldav.DAVClient(url=caldav_url, username=username, password=password, ssl_verify_cert=caldav_ssl_verify_cert)
caldav_principal = client.principal()
caldav_calendar = caldav_principal.calendar(name="Personnel")
assert(caldav_calendar)
caldav_todos = caldav_calendar.todos(sort_keys='priority', include_completed=False)
print("Here is some more icalendar data:")
for task in caldav_todos:
    print(task.vobject_instance.vtodo.summary.value)
