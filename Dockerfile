FROM debian:bullseye
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

RUN apt-get update && apt-get install -y \
	kmod \
	vim \
	avahi-daemon \
	avahi-utils \
	curl \
	iproute2 \
	libnfs-utils \
	netatalk \
	nfs-kernel-server \
	openssh-server \
	samba \
	xz-utils

RUN curl -L "https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz" | tar -xJ -C /
RUN curl -L "https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-x86_64.tar.xz" | tar -xJ -C /
#RUN cat s6-init.tar.gz | tar -C / -xz
#COPY s6-init.tar.xz /tmp
#RUN tar -C / -xJf /tmp/s6-init.tar.xz  && rm /tmp/s6-init.tar.xz
COPY etc/ /etc/

RUN mkdir /exports /run/sshd /run/dbus /run/sendsigs.omit.d 
COPY nfs-kernel-server /etc/default
COPY lockd.conf /etc/modprobe.d

#COPY afp.conf smb.conf users.conf groups.conf exports /config/
#COPY nsswitch.conf supervisord.conf /etc/
#COPY afp.service smb.service /etc/avahi/services/
#COPY entrypoint.sh healthcheck.sh nfsd.sh /scripts/

EXPOSE 22
EXPOSE 445 137/udp 138/udp
EXPOSE 548
EXPOSE 111 2049 32765 32766 32767 32768

#VOLUME ["/config", "/scripts", "/exports"] 
VOLUME ["/exports"] 

ENTRYPOINT [ "/init" ]

