#!/bin/bash

if [ ! -e "/srv/share/$TIMEMACHINE_SHARENAME/$1" ]; then
    mkdir "/srv/share/$TIMEMACHINE_SHARENAME/$1"
    # chown " /tank/time_machine/$1
    # chmod -R 700 $1 /tank/time_machine/$1
fi