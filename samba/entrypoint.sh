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
    local pathend=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_BASE/$pathend"

    # conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "follow symlinks" -a "yes" $SMBCONF
    # conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "wide links" -a "yes" "$SMBCONF"

    conf-utils add_section -y -q -s "$PUBLIC_SHARENAME" -f "pretty" "$SMBCONF"

    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "path" -a "$smbpath" "$SMBCONF"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "comment" -a "Public" "$SMBCONF"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "guest ok" -a "yes" "$SMBCONF"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "writeable" -a "yes" "$SMBCONF"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "browseable" -a "yes" -f "pretty" "$SMBCONF"
}

add_users () {
    addgroup shares
    adduser "$user" shares

    local pathend=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_BASE/$pathendi/%U"

    conf-utils add_section -y -q -s "$USERS_SHARENAME" "$SMBCONF"

    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "path" -a "$smbpath" "$SMBCONF"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "comment" -a "Users" "$SMBCONF"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "valid users" -a "$USERS_VALIDUSERS" "$SMBCONF"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "writeable" -a "yes" "$SMBCONF"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "root preexec" -a "/usr/bin/create_user_share.sh %U" -f "pretty" "$SMBCONF"
}
add_timemachine () {
    addgroup timemachine
    adduser $user timemachine

    local pathend=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_BASE/$pathend/%U"

    conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "vfs objects" -a "catia fruit streams_xattr" "$SMBCONF"
    conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "fruit:model" -a "RackMac" "$SMBCONF"

    conf-utils add_section -y -q -s "$TIMEMACHINE_SHARENAME" "$SMBCONF"

    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "path" -a "$smbpath" "$SMBCONF"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "comment" -a "TimeMachine" "$SMBCONF"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "valid users" -a "$TIMEMACHINE_VALIDUSERS" "$SMBCONF"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "writeable" -a "yes" "$SMBCONF"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "fruit:time machine" -a "yes" "$SMBCONF"
    conf-utils setvar -y -s "$TIMEMACHINE_SHARENAME" -n "root preexec" -a "/usr/bin/create_user_tm.sh %U" -f "pretty" "$SMBCONF"
}

while getopts ":u:PUTn:" opt; do
    case "$opt" in
        u )
            user="$OPTARG"
            adduser -D -H "$user"
            echo -e "buttass\nbuttass" | smbpasswd -s -a "$user"
            echo $user
        ;;
        P )
            add_public
        ;;
        U )
            add_users
        ;;
        T )
            add_timemachine
        ;;
        n )
            sharename=$(sed 's/^[[:space:]]+(.*)[[:space:]]+$/\1/' <<< $OPTARG)
        ;;
        "?")
            echo "Unknown option: -$OPTARG"; usage 1
        ;;
    esac
done
shift $((OPTIND -1))

find /srv/shares -type d ! -perm 775 -exec chmod 775 {} \;
find /srv/shares -type f ! -perm 0664 -exec chmod 0664 {} \;
chown -Rh smbuser:smb /srv/shares

ionice -c 3 nmbd -D
exec ionice -c 3 smbd -FS --no-process-group </dev/null