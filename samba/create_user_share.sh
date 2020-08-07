#!/bin/bash

user_pathcomp=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
public_pathcomp=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/srv/shares/$user_pathcomp/$1" ]; then
    zfs create "srv/shares/$user_pathcomp/$1"
    # chown $1:"shares" /tank/user/$1
    # chmod -R 700 $1 /tank/user/$1

    ln -s "/srv/shares/$public_pathcomp" "/srv/shares/$user_pathcomp/$1/Public"
fi