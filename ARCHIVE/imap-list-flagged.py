#!/usr/bin/env python3
"""
List emails with flag status set, unread email, gitea assigned issues
Requirements:
    sudo apt install python3-venv python3-pip
    python3 -m venv ~/.venv && source ~/.venv/bin/activate && pip3 install secretstorage requests
USAGE: source ~/.venv/bin/activate && imap-list-flagged.py --help
On first run the program will ask for the the required IMAP/Gitea creadentials which will be stored in your desktop environment's secret storage (e.g. gnome-keyring). These credentials can be retrieved/deleted using `secret-tool` or `seahorse` (Password and Keys gaphical application).
"""

import os
import sys
import argparse
import secretstorage
import email
import imaplib
import requests
import json
from contextlib import closing

def print_imap_subjects(conn, args, folder, criterion, symbol):
    """print subjects of messages matching the search criterion in a folder, prefixed with a symbol"""
    prefix = folder.replace('INBOX/', '') + ': '
    if args.hide_folder_names:
        prefix = ''
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
                out_line = symbol + ' ' + prefix + subject
                print(out_line[0:args.max_line_length])

def list_unread(args, folders_list, imap_credentials):
    """List unread email"""
    print('----------------- □ UNREAD -----------------------')
    conn = imaplib.IMAP4_SSL(imap_credentials['imap_server'], 993)
    conn.login(imap_credentials['imap_username'], imap_credentials['imap_password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(UNSEEN)', '□')

def list_flagged(args, folders_list, imap_credentials):
    print('----------------- ⇱ FLAGGED ----------------------')
    """List email with flagged status set"""
    conn = imaplib.IMAP4_SSL(imap_credentials['imap_server'], 993)
    conn.login(imap_credentials['imap_username'], imap_credentials['imap_password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(FLAGGED)', '⇱')

def list_gitea_assigned(args, gitea_credentials):
    print('----------------- ⊚ ASSIGNED ---------------------')
    """List gitea issues/PRs assigned to the authenticated user"""
    gitea_auth_headers = {'Authorization': 'Bearer ' + gitea_credentials['gitea_token']}
    api_url = gitea_credentials['gitea_url'] + '/api/v1/repos/issues/search?assigned=true&limit=10000&state=open'
    response = requests.get(api_url, verify=False, headers=gitea_auth_headers)
    for i in response.json():
        out_line = '⊚ ' + i['repository']['name'] + ': ' + i['title']
        print(out_line[0:args.max_line_length])

# DEBT factorize with get_gitea_credentials
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
            items = collection.search_items({'application': 'imap_utils.py'})
            item = next(items)
        imap_server = item.get_attributes()['imap_server']
        imap_username = item.get_attributes()['imap_username']
        imap_password = item.get_secret().decode("utf-8")
        return {
            'imap_server': imap_server,
            'imap_username': imap_username,
            'imap_password': imap_password
        }

# DEBT factorize with get_imap_credentials
def get_gitea_credentials():
    """retrieve gitea_server and gitea_token from secret storage,
       if not found, ask for them interactively and store them in the secret storage
    """
    with closing(secretstorage.dbus_init()) as conn:
        collection = secretstorage.get_default_collection(conn)
        items = collection.search_items({'application': 'pydashboard-gitea'})
        try:
            item = next(items)
        except StopIteration:
            print('No credentials found. Please provide Gitea server URL and Personal Access Token:')
            gitea_url = input('Enter Gitea server URL: ')
            gitea_token = input('Enter Gitea Personal Access Token: ')
            collection.create_item ('Gitea credentials (pydashboard-gitea)', {'application': 'pydashboard-gitea', 'gitea_url': gitea_url}, gitea_token)
            print('Credentials stored in secret storage.')
            items = collection.search_items({'application': 'pydashboard-gitea'})
            item = next(items)
        gitea_url = item.get_attributes()['gitea_url']
        gitea_token = item.get_secret().decode("utf-8")
        return {
            'gitea_url': gitea_url,
            'gitea_token': gitea_token
        }

def main():
    """Main loop"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--actions', dest='actions_list', type=str, default='all', help='list of actions to run, e.g. list-flagged,list-unread,gitea-assigned (default all)')
    parser.add_argument('--folders-list', dest='folders_list', type=str, default='INBOX', help='list of folders to fetch, e.g. INBOX,somedir/subdir,other (default INBOX)')
    parser.add_argument('--line-length', dest='max_line_length', type=int, default=10000, help='truncate output lines to this number of characters (default 10000)')
    parser.add_argument('--hide-folder-names', dest='hide_folder_names', action='store_true', help='dont output folder names before mail subjects')
    args = parser.parse_args()
    folders_list = args.folders_list.split(",")
    actions_list = args.actions_list.split(",")
    imap_credentials = get_imap_credentials()
    gitea_credentials = get_gitea_credentials()
    for action in actions_list:
        if action == 'all':
            list_unread(args, folders_list, imap_credentials)
            list_flagged(args, folders_list, imap_credentials)
            list_gitea_assigned(args, gitea_credentials)
        elif action == 'list-unread':
            list_unread(args, folders_list, imap_credentials)
        elif action == 'list-flagged':
            list_flagged(args, folders_list, imap_credentials)
        elif action == 'gitea-assigned':
            list_gitea_assigned(args, gitea_credentials)


if __name__ == "__main__":
    main()
