#!/bin/bash

user_pathcomp="users"
public_pathcomp="public"
smbvol="/tank"
if [ ! -e "$smbvol/$user_pathcomp/$1" ]; then
    zfs create "$smbvol/$user_pathcomp/$1"
    chown -R smbuser:smb "$smbvol/$user_pathcomp/$1"
    # chmod -R 700 $1 /tank/user/$1

    ln -s "$smbvol/$public_pathcomp" "$smbvol/$user_pathcomp/$1/Public"
fi
