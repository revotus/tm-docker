#!/bin/bash

username="$1"

tm_dirname=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
tm_path="$SMBVOL_PATH_CONTAINER/$tm_dirname/$username"

if [ ! -d  "$tm_path" ]; then
    mkdir "$tm_path"
    chown -R $SMB_UID:$SMB_GID "$tm_path"
    chmod -R 700 "$tm_path"
fi