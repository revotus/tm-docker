FROM alpine:latest
MAINTAINER Matthew Otus Benak <matt.benak@gmail.com>

WORKDIR /

RUN apk update && \
    apk add --no-cache \
        avahi \
        avahi-tools \
        xmlstarlet \
        bash

COPY ./entrypoint.sh /
COPY ./avahi-daemon.conf /etc/avahi/avahi-daemon.conf
COPY ./smb1.service /etc/cavahi/services/smb.service

VOLUME ["/var/run/dbus"]

ENTRYPOINT ["/entrypoint.sh"]