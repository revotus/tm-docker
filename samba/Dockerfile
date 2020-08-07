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
        bash && \
# rm /etc/avahi/services/*.service

# RUN mkdir /srv/shares

RUN addgroup -S smb && \
    adduser -D -H -S -G smb -h /tmp -s /usr/nologin -g "Samba User" smbuser

# USER smbuser:smb

COPY ./entrypoint.sh /
COPY ./conf-utils /usr/bin/
COPY ./smb_default.conf /etc/samba/smb.conf
COPY ./smb1.service /etc/avahi/services/smb.service

EXPOSE 137/udp 138/udp 139 445

VOLUME ["/etc/samba", "/var/log/samba", "/srv/shares"]
RUN chown -R smbuser:smb /srv/shares

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-P", "-U", "-T"]