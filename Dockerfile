FROM alpine:3.9
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

RUN apk --no-cache update &&\
    apk --no-cache add bash supervisor &&\
    apk --no-cache add samba samba-common-tools &&\
    apk --no-cache add netatalk avahi dbus &&\
    apk --no-cache add nfs-utils iproute2

RUN mkdir /scripts /config /exports /exports/samba /exports/backups /exports/nfs

COPY afp.conf smb.conf users.conf groups.conf exports /config/
COPY nsswitch.conf supervisord.conf /etc/
COPY afp.service smb.service /etc/avahi/services/
COPY entrypoint.sh healthcheck.sh nfsd.sh /scripts/

EXPOSE 445 137/udp 138/udp
EXPOSE 548
EXPOSE 111/tcp 111/udp 2049/tcp 2049/udp 32765/tcp 32765/udp 32766/tcp 32766/udp

VOLUME ["/config", "/scripts", "/exports"] 

HEALTHCHECK --retries=3 --interval=15s --timeout=5s CMD /scripts/healthcheck.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["supervisord","-c","/etc/supervisord.conf"]
 
