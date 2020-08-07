#!/bin/bash

user_pathcomp=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
public_pathcomp=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/tank/$user_pathcomp/$1" ]; then
    zfs create "tank/$user_pathcomp/$1"
    chown -R smbuser:smb "/tank/$user_pathcomp/$1"
    # chmod -R 700 $1 /tank/user/$1

    ln -s "/tank/$public_pathcomp" "/tank/$user_pathcomp/$1/Public"
fi