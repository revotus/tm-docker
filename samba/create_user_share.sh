#!/bin/bash

username="$1"

users_dirname=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
public_dirname=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
smbvol_host_dirname=${SMBVOL_HOST#/}

if [ ! -d "$SMBVOL_HOST/$users_dirname/$username" ]; then
    zfs create "$smbvol_host_dirname/$users_dirname/$username"
    chown -R $SMBUID:$SMBGID "$SMBVOL_HOST/$users_dirname/$username"
    # chmod -R 700 $1 /tank/user/$1

    ln -s "$SMBVOL_HOST/$public_dirname" "$SMBVOL_HOST/$users_dirname/$username/$PUBLIC_SHARENAME"
fi