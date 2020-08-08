#!/bin/bash

source ./.env
username="$1"

users_dirname=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
public_dirname=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')

smb_path="$SMBVOL_PATH_HOST/$users_dirname/$username"
zfs_path="${SMBVOL_PATH_HOST#/}/$users_dirname/$username"
public_path="$SMBVOL_PATH_HOST/$public_dirname"

if [ ! -d  "$smb_path" ]; then
    zfs create "$zfs_path"
    chown -R $SMBUID:$SMBGID "$smb_path"
    # chmod -R 700 $1 /tank/user/$1

    ln -s  "$public_path" "$smb_path/$PUBLIC_SHARENAME"
fi