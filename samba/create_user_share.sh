#!/bin/bash

if [ ! -e "/srv/shares/$USERSHARENAME/$1" ]; then
    zfs create "srv/shares/$USER_SHARENAME/$1"
    # chown $1:"shares" /tank/user/$1
    # chmod -R 700 $1 /tank/user/$1
    ln -s "/srv/shares/$PUBLIC_SHARENAME" "/srv/shares/$USER_SHARENAME/$1/Public"
fi