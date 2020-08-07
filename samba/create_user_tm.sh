#!/bin/bash

if [ ! -e "/srv/shares/$TIMEMACHINE_SHARENAME/$1" ]; then
    mkdir "/srv/shares/$TIMEMACHINE_SHARENAME/$1"
    # chown " /tank/time_machine/$1
    # chmod -R 700 $1 /tank/time_machine/$1
fi