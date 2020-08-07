#!/bin/bash

if [ ! -e /tank/user/$1 ]; then
    zfs create tank/user/$1
    chown $1:"shares" /tank/user/$1
    chmod -R 700 $1 /tank/user/$1
    ln -s /tank/public /tank/user/$1/Public
fi