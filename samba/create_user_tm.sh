#!/bin/bash

pathcomp=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/tank/$pathcomp/$1" ]; then
    mkdir "/tank/$pathcomp/$1"
    chown -R smbuser:smb "/tank/$pathcomp/$1"
    # chmod -R 700 $1 /tank/time_machine/$1
fi