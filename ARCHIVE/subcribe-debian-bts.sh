#!/bin/bash
# Description: subscribe to bug number on Debian bug tracking system
bts --smtp-host=smtps://$smtp_server --smtp-username=$smtp_username \
subscribe $mail_address
