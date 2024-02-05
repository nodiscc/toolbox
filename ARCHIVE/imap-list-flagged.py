#!/usr/bin/env python3
# TODO add support for CalDAV events, merge from get_caldav_events.py
"""
Command-line tool to fetch info from various sources and display them in a short, actionable list.
Supports IMAP flagged messages, Gitea assigned issues/PRs, TT-RSS starred articles, Toggl Track time
entries.
Requirements:
  sudo apt install python3-venv python3-pip
  python3 -m venv ~/.venv && source ~/.venv/bin/activate && pip3 install secretstorage requests
USAGE: source ~/.venv/bin/activate && ./pywip --help
On first run the program will ask for the required credentials for each service, and store them in
your desktop environment's secret storage (e.g. gnome-keyring). These credentials can be retrieved
or deleted using `secret-tool` or `seahorse` (`Password and Keys` graphical application).
"""

import os
import sys
import argparse
import secretstorage
import email
import imaplib
import requests
import json
import decimal
import datetime
from contextlib import closing
from base64 import b64encode

def list_unread(args, folders_list):
    """List unread email"""
    # TODO support for multiple IMAP accounts
    imap_credentials = get_credentials(
        application_name='pydashboard-imap',
        secret_collection_title='IMAP credentials (pywip)',
        server_address_question_label="Enter IMAP server address: ",
        username_question_label="Enter IMAP username: ",
        password_question_label="Enter IMAP password: ")
    print('----------------- □ UNREAD -----------------------')
    conn = imaplib.IMAP4_SSL(imap_credentials['server_address'], 993)
    conn.login(imap_credentials['username'], imap_credentials['password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(UNSEEN)', '□')

def list_flagged(args, folders_list):
    """List email with flagged status set"""
    # TODO support for multiple IMAP accounts
    imap_credentials = get_credentials(
        application_name='pydashboard-imap',
        secret_collection_title='IMAP credentials (pywip)',
        server_address_question_label="Enter IMAP server address: ",
        username_question_label="Enter IMAP username: ",
        password_question_label="Enter IMAP password: ")
    print('----------------- ⇱ FLAGGED ----------------------')
    conn = imaplib.IMAP4_SSL(imap_credentials['server_address'], 993)
    conn.login(imap_credentials['username'], imap_credentials['password'])
    for folder in folders_list:
        print_imap_subjects(conn, args, folder, '(FLAGGED)', '⇱')

def list_gitea_assigned(args):
    """List gitea issues/PRs assigned to the authenticated user"""
    # DOC https://try.gitea.io/api/swagger
    # TODO doc: must generate token from https://GITEA_URL/user/settings/applications
    gitea_credentials = get_credentials(
        application_name='pydashboard-gitea',
        secret_collection_title='Gitea credentials (pywip)',
        server_address_question_label="Enter Gitea server URL: ",
        username_question_label=None,
        password_question_label="Enter Gitea Personal Access Token: ")
    print('----------------- ⊚ ASSIGNED ---------------------')
    gitea_auth_headers = {'Authorization': 'Bearer ' + gitea_credentials['password']}
    api_url = gitea_credentials['server_address'] + '/api/v1/repos/issues/search?assigned=true&limit=10000&state=open'
    response = requests.get(api_url, verify=False, headers=gitea_auth_headers)
    for i in response.json():
        out_line = '⊚ ' + i['repository']['name'] + ': ' + i['title']
        print(out_line[0:args.max_line_length])

def list_ttrss_marked(args):
    """List TT-RSS starred articles"""
    # DOC: https://tt-rss.org/wiki/ApiReference
    # TODO doc: must create an app password under preferences > personal data/authentication > app passwords > generate password
    ttrss_credentials = get_credentials(
        application_name='pydashboard-ttrss',
        secret_collection_title='TT-RSS credentials (pywip)',
        server_address_question_label="Enter TT-RSS server URL: ",
        username_question_label="Enter TT-RSS username: ",
        password_question_label="Enter TT-RSS password: ")
    print('----------------- ⊚ TT-RSS MARKED ----------------')
    ttrss_session = requests.Session()
    tt_rss_login_data = json.dumps({
        "op": "login",
        "user": ttrss_credentials['username'],
        "password": ttrss_credentials['password']})
    tt_rss_headers = {"Content-Type": "application/json"}
    response = ttrss_session.post(
        ttrss_credentials['server_address'] + '/api/',
        verify=False,
        headers=tt_rss_headers,
        data=tt_rss_login_data)
    auth = json.loads(response.text)
    session_id = auth['content']['session_id']
    tt_rss_query_data = json.dumps({
        "sid": session_id,
        "op": "getHeadlines",
        "feed_id": -1,
        "view_mode": "all_articles",
        "feed_dates": "date_reverse"})
    response = ttrss_session.post(
        ttrss_credentials['server_address'] + '/api/',
        verify=False,
        headers=tt_rss_headers,
        data=tt_rss_query_data)
    data = json.loads(response.text)
    for article in data['content']:
        out_line = '▽ ' + article['title']
        print(out_line[0:args.max_line_length])

def list_toggl_week_totals(args):
    """Compute total hours per week filed on Toggl Track, compute overtime"""
    # DOC: https://developers.track.toggl.space/docs/api/time_entries
    # TODO doc: must get token from https://track.toggl.com/profile
    toggltrack_credentials = get_credentials(
        application_name='pydashboard-toggltrack',
        secret_collection_title='Toggl Track credentials (pywip)',
        server_address_question_label=None,
        username_question_label=None,
        password_question_label="Enter Toggl Track token: ")
    print('----------------- ◕ TIMETRACKING ----------------')
    print('WEEK                      HRS    OVERTIME')
    toggl_api_token = toggltrack_credentials['password']
    toggl_auth = "{}:api_token".format(toggl_api_token).encode('UTF-8')
    start_date = datetime.datetime.strptime('2024-01-01', '%Y-%m-%d')
    end_date = start_date + datetime.timedelta(days=6)
    target_hours_per_week = '36.25'
    total_overtime = 0
    now = datetime.datetime.now()
    decimal.getcontext().prec = 4
    toggl_headers = {
        'content-type': 'application/json',
        'Authorization' : 'Basic %s' % b64encode(toggl_auth).decode("ascii")}
    while start_date < now:
        toggl_params = {
            'start_date': start_date.strftime('%Y-%m-%d'),
            'end_date': end_date.strftime('%Y-%m-%d')}
        data = requests.get(
            'https://api.track.toggl.com/api/v9/me/time_entries',
            headers=toggl_headers,
            params=toggl_params)
        j = json.loads(data.text)
        total_duration_sec = 0
        for time_entry in j:
            total_duration_sec = total_duration_sec + time_entry['duration']
        total_duration_hours = decimal.Decimal(total_duration_sec) / decimal.Decimal(3600.00)
        overtime = decimal.Decimal(total_duration_hours) - decimal.Decimal(target_hours_per_week)
        print("{} to {}: {} {}H".format(
            start_date.strftime('%Y-%m-%d'),
            end_date.strftime('%Y-%m-%d'),
            (str(total_duration_hours) + 'H').ljust(6, ' '),
            overtime))
        total_overtime = total_overtime + overtime
        start_date = start_date + datetime.timedelta(days=7)
        end_date = end_date + datetime.timedelta(days=7)
    print('◔ TOTAL OVERTIME ON THIS PERIOD: {}H'.format(total_overtime))

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

def get_credentials(application_name, secret_collection_title,
                    server_address_question_label, username_question_label,
                    password_question_label):
    """
    Retrieve credentials from secret storage, if none found matching application_name,
    create a collection containing the credentials
    """
    with closing(secretstorage.dbus_init()) as conn:
        collection = secretstorage.get_default_collection(conn)
        items = collection.search_items({'application': application_name})
        try:
            item = next(items)
        except StopIteration:
            new_collection = {'application': application_name}
            print('No credentials found. Please provide them now:')
            if server_address_question_label is not None:
                server_address = input(server_address_question_label)
                new_collection['server_address'] = server_address
            if username_question_label is not None:
                username = input(username_question_label)
                new_collection['username'] = username
            password = input(password_question_label)
            collection.create_item (secret_collection_title, new_collection, password)
            print('Credentials stored in secret storage.')
            items = collection.search_items({'application': application_name})
            item = next(items)
        credentials = {}
        if server_address_question_label is not None:
            credentials['server_address'] = item.get_attributes()['server_address']
        if username_question_label is not None:
            credentials['username'] = item.get_attributes()['username']
        credentials['password'] = item.get_secret().decode("utf-8")
        return credentials

def main():
    """Main loop"""
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawTextHelpFormatter)
    parser.add_argument('--actions', dest='actions_list', type=str, default='all', help='list of actions to run, e.g. list-flagged,list-unread,gitea-assigned,ttrss-marked,toggl-timer (default all)')
    parser.add_argument('--folders-list', dest='folders_list', type=str, default='INBOX', help='list of folders to fetch, e.g. INBOX,somedir/subdir,other (default INBOX)')
    parser.add_argument('--line-length', dest='max_line_length', type=int, default=10000, help='truncate output lines to this number of characters (default 10000)')
    parser.add_argument('--hide-folder-names', dest='hide_folder_names', action='store_true', help='dont output folder names before mail subjects')
    args = parser.parse_args()
    folders_list = args.folders_list.split(",")
    actions_list = args.actions_list.split(",")
    for action in actions_list:
        if action == 'all':
            list_unread(args, folders_list)
            list_flagged(args, folders_list)
            list_gitea_assigned(args)
            list_ttrss_marked(args)
        elif action == 'list-unread':
            list_unread(args, folders_list)
        elif action == 'list-flagged':
            list_flagged(args, folders_list)
        elif action == 'gitea-assigned':
            list_gitea_assigned(args)
        elif action == 'ttrss-marked':
            list_ttrss_marked(args)
        elif action == 'toggl-timer':
            list_toggl_week_totals(args)

if __name__ == "__main__":
    main()
