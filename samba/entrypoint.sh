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
    -u \"<username;password>[;share;timemachine]\"       Add a user
                required arg: \"<username>;<passwd>\"
                <username> for user
                <password> for user
                [sharer] create share for user default: yes or no
                [timemachine] create timemachine backup for user default: yes or no
    -U \"<user yml file>\"      user file in YAML format. See example.

" >&2
    exit $RC
}

add_public () {
    local dirname=$(echo "$PUBLIC_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_PATH_CONTAINER/$dirname"

    # conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "follow symlinks" -a "yes" $SMB_CONFFILE

    conf-utils add_section -y -q -s "$PUBLIC_SHARENAME" -f "pretty" "$SMB_CONFFILE"

    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "path" -a "$smbpath" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "comment" -a "$PUBLIC_SHARENAME" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "guest ok" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "writeable" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$PUBLIC_SHARENAME" -n "browseable" -a "yes" -f "pretty" "$SMB_CONFFILE"
}

add_users () {
    local dirname=$(echo "$USERS_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_PATH_CONTAINER/$dirname/%U"

    conf-utils add_section -y -q -s "$USERS_SHARENAME" -f "pretty" "$SMB_CONFFILE"

    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "path" -a "$smbpath" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "comment" -a "$USERS_SHARENAME" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "valid users" -a "@$SHARES_GROUP" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$USERS_SHARENAME" -n "writeable" -a "yes" -f "pretty" "$SMB_CONFFILE"
    # conf-utils setvar -y -s "$USERS_SHARENAME" -n "root preexec" -a "/usr/bin/create_user_share.sh %U" -f "pretty" "$SMB_CONFFILE"
}

add_timemachine () {
    local dirname=$(echo "$TIMEMACHINE_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local smbpath="$SMBVOL_PATH_CONTAINER/$dirname/%U"

    conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "vfs objects" -a "catia fruit streams_xattr" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "fruit:model" -a "TimeCapsule8,119" "$SMB_CONFFILE"

    conf-utils add_section -y -q -s "$TIMEMACHINE_SHARENAME" "$SMB_CONFFILE"

    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "path" -a "$smbpath" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "comment" -a "$TIMEMACHINE_SHARENAME" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "valid users" -a "@$TIMEMACHINE_GROUP" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "writeable" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "fruit:time machine" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "fruit:time machine max size" -a "1T" "$SMB_CONFFILE"
    # conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "fruit:resource" -a "xattr" "$SMB_CONFFILE"
    # conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "fruit:metadata" -a "stream" "$SMB_CONFFILE"
    # conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "veto files" -a "/._*/.DS_Store/" "$SMB_CONFFILE"
    # conf-utils setvar -y -q -s "$TIMEMACHINE_SHARENAME" -n "delete veto files" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -s "$TIMEMACHINE_SHARENAME" -n "root preexec" -a "/usr/bin/create_user_tm.sh %U" -f "pretty" "$SMB_CONFFILE"
}

add_volumio () {

    local dirname=$(echo "$VOLUMIO_SHARENAME" | tr '[:upper:]' '[:lower:]')
    local volumio_path="$MEDIA_PATH_CONTAINER/$dirname"
    echo $volumio_path

    # conf-utils setvar -y -q -s "$GLOBAL_SHARENAME" -n "follow symlinks" -a "yes" $SMB_CONFFILE

    conf-utils add_section -y -q -s "$VOLUMIO_SHARENAME" -f "pretty" "$SMB_CONFFILE"

    conf-utils setvar -y -q -s "$VOLUMIO_SHARENAME" -n "path" -a "$volumio_path" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$VOLUMIO_SHARENAME" -n "comment" -a "$VOLUMIO_SHARENAME" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$VOLUMIO_SHARENAME" -n "guest ok" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -q -s "$VOLUMIO_SHARENAME" -n "writeable" -a "yes" "$SMB_CONFFILE"
    conf-utils setvar -y -s "$VOLUMIO_SHARENAME" -n "browseable" -a "yes" -f "pretty" "$SMB_CONFFILE"
}

user () {
    local name="$1"
    local passwd="$2"
    local share="${3:-"yes"}"
    local tm="${4:-"yes"}"

    adduser -D -H "$name"
    echo -e "$passwd\n$passwd" | smbpasswd -s -a "$name"

    grep -q "^$SHARES_GROUP:" /etc/group || addgroup -S "$SHARES_GROUP"
    grep -q "^$TIMEMACHINE_GROUP:" /etc/group || addgroup -S "$TIMEMACHINE_GROUP"

    [ "$share" == "no" ] || adduser "$name" "$SHARES_GROUP"
    [ "$tm" == "no" ] || adduser "$name" "$TIMEMACHINE_GROUP"
}

userfile () {
    len=$(yq read -l $USERFILE)
    for (( i=0; i<"$len"; i++ )); do

        name=$(yq read "$USERFILE" "[$i].name")
        passwd=$(yq read "$USERFILE" "[$i].passwd")
        user "$name" "$passwd"
    done
}

user_opts="U:u:"
share_opts="PSTV"

while getopts ":$user_opts" opt; do
    case "$opt" in
        U )
            USERFILE="$OPTARG"
        ;;
        u )
            user $(sed 's/^/"/; s/$/"/; s/;/" "/g' <<< $OPTARG)
        ;;
        "?")
            if $(echo "$share_opts" | grep -qv $OPTARG); then
                echo "Unknown option: -$OPTARG"; usage 1
            fi
        ;;
        : )
            echo "No argument value for option: -$OPTARG"; usage 2
        ;;
    esac
done
# shift $((OPTIND -1))
OPTIND=1

userfile

while getopts ":$share_opts" opt; do
    case "$opt" in
        P )
            add_public
        ;;
        S )
            add_users
        ;;
        T )
            add_timemachine
        ;;
        V )
            add_volumio
        ;;
        "?")
            if $(echo "$user_opts" | grep -qv $OPTARG); then
                echo "Unknown option: -$OPTARG"; usage 1
            else
                OPTIND=$((OPTIND +1))
            fi
        ;;
    esac
done
shift $((OPTIND -1))

find "$SMBVOL_PATH_CONTAINER" -type d ! -perm 775 -exec chmod 775 {} \;
find "$SMBVOL_PATH_CONTAINER" -type f ! -perm 0664 -exec chmod 0664 {} \;
chown -Rh "$SMB_UID:$SMB_GID" "$SMBVOL_PATH_CONTAINER"

# ionice -c 3 nmbd -D
exec ionice -c 3 smbd -FS --no-process-group </dev/null