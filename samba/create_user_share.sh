#!/bin/bash

local user_pathend=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
local public_pathend=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/srv/shares/$user_pathend/$1" ]; then
    zfs create "srv/shares/$user_pathend/$1"
    # chown $1:"shares" /tank/user/$1
    # chmod -R 700 $1 /tank/user/$1

    ln -s "/srv/shares/$public_pathend" "/srv/shares/$user_pathend/$1/Public"
fi