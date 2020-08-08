#!/bin/bash

username="$1"

tm_dirname=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
tm_path="$SMBVOL_PATH_CONTAINER/$tm_dirname/$username"

if [ ! -d  "$tm_path"]; then
    mkdir "$tm_path"
    chown -R $SMBUID:$SMBGID "$tm_path"
    # chmod -R 700 $1 /tank/time_machine/$1
fi