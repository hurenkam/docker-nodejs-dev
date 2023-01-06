FROM docker.io/hurenkam/debian-cockpit
MAINTAINER Mark Hurenkamp <mark.hurenkamp@xs4all>

# install basic packages
RUN apt-get update && apt-get install -y \
	curl \
	git \
	wget

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -

# install node-js packages
RUN apt-get update && apt-get install -y \
        nodejs

# install node-red packages
WORKDIR /usr/local/node-red
COPY ./ /usr/local/node-red
RUN npm install node-red

# copy overlay directories
COPY etc/ /etc/



# clean-up
RUN apt-get autoremove -y && \
    apt-get clean && \
    rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/* \
    /var/log/alternatives.log \
    /var/log/apt/history.log \
    /var/log/apt/term.log \
    /var/log/dpkg.log



# Build final image.
# Create an image without the deleted files in the intermediate layers.

FROM docker.io/hurenkam/debian-cockpit
COPY --from=0 / /

# expose ssh port
EXPOSE 22

# expose cockpit port
EXPOSE 9090


# configure systemd
ENV container docker
STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup", "/home"] 

CMD [ "/sbin/init" ]



# TODO:
# - set root password

