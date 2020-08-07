#!/bin/bash

local pathend=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/srv/shares/$pathend/$1" ]; then
    mkdir "/srv/shares/$pathend/$1"
    # chown " /tank/time_machine/$1
    # chmod -R 700 $1 /tank/time_machine/$1
fi