#!/bin/bash

user_pathcomp=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
public_pathcomp=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "$SMBVOL_BASE/$user_pathcomp/$1" ]; then
    zfs create "$SMBVOL_BASE/$user_pathcomp/$1"
    chown -R smbuser:smb "$SMBVOL_BASE/$user_pathcomp/$1"
    # chmod -R 700 $1 /tank/user/$1

    ln -s "$SMBVOL_BASE/$public_pathcomp" "$SMBVOL_BASE/$user_pathcomp/$1/Public"
fi