: MAP NETWORK DRIVES
set user_name="MEDIACD\prenom.nom"
net use X: \\10.0.0.21\SHARE1 /USER:%user_name% /Persistent:Yes
net use Y: \\10.0.0.21\SHARE2 /USER:%user_name% /Persistent:Yes
