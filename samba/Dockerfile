FROM alpine:latest
MAINTAINER Matthew Otus Benak <matt.benak@gmail.com>

WORKDIR /

RUN apk update && \
    apk add --no-cache \
        samba \
        # samba-common-tools \
        # samba-server \
        # avahi \
        # avahi-tools \
        # avahi-compat-libdns_sd \
        # dbus \
        zfs \
        bash \
        curl \
        wget
RUN wget $(curl -s https://api.github.com/repos/mikefarah/yq/releases/latest \
        | grep browser_download_url | grep linux_arm64 | cut -d '"' -f 4) \
        -O /usr/bin/yq && \
    chmod +x /usr/bin/yq
RUN rm /etc/samba/smb.conf
#rm /etc/avahi/services/*.service

# RUN mkdir /srv/shares

RUN addgroup -S --gid 6969 smb && \
    adduser -D -H -S -G smb -h /tmp -s /usr/nologin -g "Samba User" -u 6969 smbuser


# USER smbuser:smb

COPY ./entrypoint.sh /
COPY ./conf-utils /usr/bin/
COPY ./smb_default.conf /etc/samba/smb.conf
COPY ./create_user_tm.sh /usr/bin/
COPY ./create_user_share.sh /usr/bin/
COPY ./smb.service /etc/avahi/services/smb.service

EXPOSE 137/udp 138/udp 445

VOLUME ["/etc/samba", "/var/log/samba", "/srv/shares"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-u", "motus", "-P", "-U", "-T"]