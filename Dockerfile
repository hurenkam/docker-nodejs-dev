FROM debian:bullseye
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

# install base packages
# systemd / ssh / vim / ip utils
RUN apt-get update && apt-get install -y \
	systemd \
	systemd-sysv \
        cron \
        anacron \
	openssh-server \
	vim \
	iproute2

# install minimum cockpit packages
# for system administration
RUN apt-get update && apt-get install -y \
	cockpit-bridge \
	cockpit-ws \
	cockpit-system


# install fileserver related packages
# avahi / nfs / afp / samba
RUN apt-get update && apt-get install -y \
	avahi-daemon \
	avahi-utils \
	libnfs-utils \
	netatalk \
	nfs-kernel-server \
	samba 

# install wsdd daemon
# this will announce the samba shares using SMB2 protocol
RUN echo "deb https://pkg.ltec.ch/public/ bullseye main" > /etc/apt/sources.list.d/wsdd.list
RUN apt-key adv --fetch-keys https://pkg.ltec.ch/public/conf/ltec-ag.gpg.key
RUN apt-get update && apt-get install -y wsdd


# install cockpit-file-sharing
RUN apt-get update && apt-get install -y \
	git \
	make

RUN cd /root && git clone https://github.com/45Drives/cockpit-file-sharing.git && cd cockpit-file-sharing && make install


# clean-up after apt
RUN apt-get clean && rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/history.log \
    /var/log/apt/term.log \
    /var/log/dpkg.log


# clean-up unwanted systemd dependencies
RUN cd /lib/systemd/system/sysinit.target.wants/ \
    && rm $(ls | grep -v systemd-tmpfiles-setup)

RUN rm -f \
    /lib/systemd/system/multi-user.target.wants/* \
    /etc/systemd/system/*.wants/* \
    /lib/systemd/system/local-fs.target.wants/* \
    /lib/systemd/system/sockets.target.wants/*udev* \
    /lib/systemd/system/sockets.target.wants/*initctl* \
    /lib/systemd/system/basic.target.wants/* \
    /lib/systemd/system/anaconda.target.wants/* \
    /lib/systemd/system/plymouth* \
    /lib/systemd/system/systemd-update-utmp*

RUN rm -f \
    /etc/machine-id \
    /var/lib/dbus/machine-id

RUN systemctl mask -- \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount


# create required directories
RUN mkdir /config /scripts /exports /exports/nfs 

# copy overlay directories
COPY etc/ /etc/
COPY config/ /config/
COPY scripts/ /scripts/


# expose ssh port
EXPOSE 22

# expose samba ports
EXPOSE 445 137/udp 138/udp

# expose afp port
EXPOSE 548

# expose nfs ports
EXPOSE 111 2049 32765 32766 32767 32768

# expose cockpit port
EXPOSE 9090


# configure systemd
ENV container docker
STOPSIGNAL SIGRTMIN+3


VOLUME ["/sys/fs/cgroup","/run","/run/lock","/tmp"] 

CMD [ "/sbin/init" ]


# TODO:
# - set root password

