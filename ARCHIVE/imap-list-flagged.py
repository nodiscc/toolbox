#!/usr/bin/env python3
"""
List emails with flag status set, or unread email.
Requirements: sudo apt install python3-venv python3-pip && python3 -m venv ~/.venv && source ~/.venv/bin/activate && pip3 install secretstorage
USAGE: source ~/.venv/bin/activate && imap-list-flagged.py --help
On first run the program will ask for the IMAP server, username and password which will be stored in your desktop environment's secret storage (e.g. gnome-keyring). These credentials can be retrieved/deleted using secret-tool or seahorse

Example output:
$ imap-list-flagged.py --folders-list INBOX,accounts,admin,admin/AWESOME-SELFHOSTED,admin/Debian,admin/infra,admin/Other
❑ INBOX: Security alert
❑ INBOX: Your Steam account: Access from new web or mobile device
❑ admin/AWESOME-SELFHOSTED: [awesome-selfhosted/awesome-selfhosted-data] Add bitmagnet (PR #558)
❑ admin/Other: awesome-linuxaudio | more suggestion points (not an issue) (#13)
⚑ admin/Debian: [Debian Wiki] Update of "Firefox" by LinhPham
⚑ admin/infra: Warning, Disk /var space usage = 96.3%, on my.example.org
⚑ admin/infra: Warning, apt_upgradable = 1 packages, on my.example.org
⚑ admin/infra: Warning, apt_upgradable = 2 packages, on my.example.net
"""

import os
import sys
import argparse
import secretstorage
import email
import imaplib
from contextlib import closing

def print_imap_subjects(conn, args, folder, criterion, symbol):
    """print subjects of messages matching the search criterion in a folder, prefixed with a symbol"""
    prefix = ''
    if args.show_folder_names:
        prefix = folder.replace('INBOX/', '') + ': '
    conn.select(folder, readonly=True)
    imap_status, imap_response = conn.search(None, criterion)
    message_uids = imap_response[0].split()
    # print("[INFO] {} unread messages in {}".format(len(message_uids), folder))
    for message_uid in message_uids:
        status, message_data = conn.fetch(message_uid, '(BODY.PEEK[HEADER])')
        for response_part in message_data:
            if isinstance(response_part, tuple):
                msg = email.message_from_bytes(response_part[1])
                decoded_header, encoding = email.header.decode_header(msg['Subject'])[0]
                if isinstance(decoded_header, bytes):
                    subject = decoded_header.decode(encoding).replace('\r', '').replace('\n', '')
                else:
                    subject = decoded_header.replace('\r', '').replace('\n', '')
                print(symbol + ' ' + prefix + subject[0:args.subject_max_length])

def list_unread(args, folders_list, imap_credentials):
    """List unread email"""
    conn = imaplib.IMAP4_SSL(imap_credentials['imap_server'], 993)
    conn.login(imap_credentials['imap_username'], imap_credentials['imap_password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(UNSEEN)', '❑')

def list_flagged(args, folders_list, imap_credentials):
    """List email with flagged status set"""
    conn = imaplib.IMAP4_SSL(imap_credentials['imap_server'], 993)
    conn.login(imap_credentials['imap_username'], imap_credentials['imap_password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(FLAGGED)', '⚑')

def get_imap_credentials():
    """retrieve imap_server, imap_username, imap_password from secret storage,
       if not found, ask for them interactively and store them in the secret storage
    """
    with closing(secretstorage.dbus_init()) as conn:
        collection = secretstorage.get_default_collection(conn)
        items = collection.search_items({'application': 'imap_utils.py'})
        try:
            item = next(items)
        except StopIteration:
            print('No credentials found. Please provide IMAP server, username and password:')
            imap_server = input('Enter IMAP server address: ')
            imap_username = input('Enter IMAP username: ')
            imap_password = input('Enter IMAP password: ')
            collection.create_item ('IMAP credentials (imap_utils.py)', {'application': 'imap_utils.py', 'imap_server': imap_server, 'imap_username': imap_username}, imap_password)
            print('Credentials stored in secret storage.')
            item = next(items)
        imap_server = item.get_attributes()['imap_server']
        imap_username = item.get_attributes()['imap_username']
        imap_password = item.get_secret().decode("utf-8")
        return {
            'imap_server': imap_server,
            'imap_username': imap_username,
            'imap_password': imap_password
        }

def main():
    """Main loop"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--actions', dest='actions_list', type=str, default='all', help='list of actions to run, e.g. list-flagged,list-unread (default all)')
    parser.add_argument('--folders-list', dest='folders_list', type=str, default='INBOX', help='list of folders to fetch, e.g. INBOX,somedir/subdir,other (default INBOX)')
    parser.add_argument('--line-length', dest='subject_max_length', type=int, default=10000, help='truncate mail subjects to this number of characters (default 10000)')
    parser.add_argument('--folder-names', dest='show_folder_names', type=bool, default=True, help='show folder names before mail subjects (default True)')
    args = parser.parse_args()
    folders_list = args.folders_list.split(",")
    actions_list = args.actions_list.split(",")
    imap_credentials = get_imap_credentials()
    for action in actions_list:
        if action == 'all':
            list_unread(args, folders_list, imap_credentials)
            list_flagged(args, folders_list, imap_credentials)
        elif action == 'list-unread':
            list_unread(args, folders_list, imap_credentials)
        elif action == 'list-flagged':
            list_flagged(args, folders_list, imap_credentials)


if __name__ == "__main__":
    main()
