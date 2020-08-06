FROM alpine:latest
MAINTAINER Matthew Otus Benak <matt.benak@gmail.com>

WORKDIR /

RUN apk update && \
    apk add --no-cache \
        samba \
        bash

# RUN mkdir /srv/shares

RUN addgroup -S smb && \
    adduser -D -H -S -G smb -h /tmp -s /usr/nologin -g "Samba User" smbuser

# USER smbuser:smb

COPY ./entrypoint.sh /
COPY ./conf-utils /usr/bin/
COPY ./smb_default.conf /etc/samba/smb.conf

VOLUME ["/etc/samba", "/var/log/samba", "/srv/shares"]

ENTRYPOINT ["/entrypoint.sh"]

CMD ["-P", "-U"]