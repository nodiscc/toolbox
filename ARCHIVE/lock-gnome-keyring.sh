#!/bin/bash
#Description: Lock GNOME keyrings (currently only 'login' and 'mozilla' keyrings)

python -c "import gnomekeyring;gnomekeyring.lock_sync('login');gnomekeyring.lock_sync('mozilla')"
