#!/bin/bash

usage() {
    local RC="${1:-0}"
    local cmdname=${0##*/}

    echo "Usage: $cmdname [-opt] [command]

Options (fields in '[]' are optional, '<>' are required):
    -h              Show this
    -P              Create Public share
    -U              Create Users share
    -T              Create TimeMachine share
    -n     \"<name>\" name of share
    -u     \"<users>\" commma separated user list

" >&2
    exit $RC
}

new() {
    local name="${1:-$USER_SHARENAME}"
    local users="${2:-$USER_VALID}"
}

add_public () {
    local pathend=$(echo $PUBLIC_SHARENAME | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_BASE/$pathend"

    conf-utils setvar -y -q -s $GLOBAL_SHARENAME -n "follow symlinks" -a yes $SMB_CONF
    conf-utils setvar -y -q -s $GLOBAL_SHARENAME -n "wide links" -a yes $SMB_CONF

    conf-utils add_section -y -q -s $PUBLIC_SHARENAME $SMB_CONF

    conf-utils setvar -y -q -s $PUBLIC_SHARENAME -n "path" -a "$smbpath" $SMB_CONF
    conf-utils setvar -y -q -s $PUBLIC_SHARENAME -n "comment" -a "Public" $SMB_CONF
    conf-utils setvar -y -q -s $PUBLIC_SHARENAME -n "guest ok" -a yes $SMB_CONF
    conf-utils setvar -y -q -s $PUBLIC_SHARENAME -n "writeable" -a yes -f pretty $SMB_CONF
}

add_users () {
    local pathend=$(echo $USERS_SHARENAME | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_BASE/$pathend"

    conf-utils add_section -y -q -s $USERS_SHARENAME $SMB_CONF

    conf-utils setvar -y -q -s $USERS_SHARENAME -n "path" -a "$smbpath" $SMB_CONF
    conf-utils setvar -y -q -s $USERS_SHARENAME -n "comment" -a "Users" $SMB_CONF
    conf-utils setvar -y -q -s $USERS_SHARENAME -n "writeable" -a yes -f pretty $SMB_CONF
}

while getopts ":PUTn:u:" opt; do
    case "$opt" in
        P )
            add_public
        ;;
        U )
            add_users
        ;;
        T )
            echo "TimeMachine"
        ;;
        n )
            sharename=$(sed 's/^[[:space:]]+(.*)[[:space:]]+$/\1/' <<< $OPTARG)
        ;;
        u )
            shareusers=$(sed 's/^/"/; s/$/"/' <<< $OPTARG)
        ;;
        "?")
            echo "Unknown option: -$OPTARG"; usage 1
        ;;
    esac
done
shift $((OPTIND -1))

cat /etc/samba/smb.conf
exec /usr/sbin/smbd --no-process-group --log-stdout --foreground
