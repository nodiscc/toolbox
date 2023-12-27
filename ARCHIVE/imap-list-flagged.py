#!/usr/bin/env python3
# Description: list mails with flag status set
# Requirements: python3-venv python3-pip, python3 -m venv ~/.venv && source ~/.venv/bin/activate && pip3 install imap_tools
# USAGE: source ~/.venv/bin/activate && ~/outlook-flagged.py

SERVER='ex4.mail.ovh.net'
USERNAME='example@outlook.com'
PASSWORD='AAbbbZZZhhhhgsggg'
FOLDERS = ['INBOX',
            'INBOX/FOLDER1',
            'INBOX/FOLDER2',
            'INBOX/FOLDER3',
            'INBOX/FOLDER4',
            'INBOX/FOLDER5',
            'INBOX/FOLDER6']

from imap_tools import MailBox, AND

for folder in FOLDERS:
    with MailBox(SERVER).login(USERNAME, PASSWORD, folder) as mailbox:
        subjects = [msg.subject for msg in mailbox.fetch(AND(flagged=True))]
        for subject in subjects:
            subject = subject.replace("\r\n", " ")
            print('- ' + folder.replace('INBOX/', '') + ': ' + subject)

