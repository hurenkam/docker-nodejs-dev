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

RUN mkdir /config /scripts /exports /exports/nfs /run/sshd /run/dbus /run/sendsigs.omit.d 
RUN curl -L "https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-noarch.tar.xz" | tar -xJ -C /
RUN curl -L "https://github.com/just-containers/s6-overlay/releases/download/v3.1.0.1/s6-overlay-x86_64.tar.xz" | tar -xJ -C /
COPY etc/ /etc/
COPY config/ /config/
COPY scripts/ /scripts/

EXPOSE 22
EXPOSE 445 137/udp 138/udp
EXPOSE 548
EXPOSE 111 2049 32765 32766 32767 32768

VOLUME ["/config"] 

ENTRYPOINT [ "/init" ]

