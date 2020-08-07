#!/bin/bash

pathcomp=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
if [ ! -e "/srv/shares/$pathcomp/$1" ]; then
    mkdir "/srv/shares/$pathcomp/$1"
    chown -R smbuser:smb "/srv/shares/$pathcomp/$1"
    # chmod -R 700 $1 /tank/time_machine/$1
fi