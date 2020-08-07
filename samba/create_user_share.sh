#!/bin/bash

if [ ! -e "/tank/$USERSHARENAME/$1" ]; then
    zfs create "tank/$USER_SHARENAME/$1"
    # chown $1:"shares" /tank/user/$1
    # chmod -R 700 $1 /tank/user/$1
    ln -s "/tank/$PUBLIC_SHARENAME" "/tank/$USER_SHARENAME/$1/Public"
fi