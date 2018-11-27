FROM hurenkam/alpine:latest
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

RUN apk --no-cache update &&\
    apk --no-cache add samba samba-common-tools supervisor bash &&\
    apk --no-cache add netatalk avahi dbus

RUN mkdir /scripts /config /exports /exports/samba /exports/timemachine &&\

COPY afp.conf smb.conf users.conf groups.conf /config/
COPY nsswitch.conf supervisord.conf /etc/
COPY afpd.service /etc/avahi/services/
COPY entrypoint.sh healthcheck.sh /scripts/

EXPOSE 445 137/udp 138/udp 548

VOLUME ["/config", "/scripts", "/exports"] 

HEALTHCHECK --retries=3 --interval=15s --timeout=5s CMD /setup/healthcheck.sh
ENTRYPOINT ["/scripts/entrypoint.sh"]
CMD ["supervisord","-c","/etc/supervisord.conf"]
 
