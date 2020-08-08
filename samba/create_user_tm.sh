#!/bin/bash

username="$1"

tm_dirname=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -d "$SMBVOL_CONTAINER/$tm_dirname/$username" ]; then
    mkdir "$SMBVOL_CONTAINER/$tm_dirname/$username"
    chown -R $SMBUID:$SMBGID "$SMBVOL_CONTAINER/$tm_dirname/$username"
    # chmod -R 700 $1 /tank/time_machine/$1
fi