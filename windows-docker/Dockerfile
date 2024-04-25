FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependent packages
RUN apt-get -y update
RUN apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm libssl-dev vim bash-completion locales screen sudo minicom curl python3-serial nfs-kernel-server python3-tk libserial-dev tftpd-hpa

RUN pip3 install pyserial keyboard pylink

# Generate and set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Make sure /bin/sh points to bash
RUN ln -sf bash /bin/sh

# Create static user for building Linux images
ARG USERNAME=apssbuilder

ARG PUID=1000

ARG PGID=1000

# HACK: create hidden file ~/.windows_docker to identify Windows 11 docker container.
RUN groupadd -g ${PGID} ${USERNAME} \
            && useradd -u ${PUID} -g ${USERNAME} -d /home/${USERNAME} ${USERNAME} \
            && mkdir /home/${USERNAME} \
            && touch /home/${USERNAME}/.windows_docker \
            && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}

RUN echo "${USERNAME}  ALL=(ALL)       NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null
RUN sed -i "s:^Defaults\tsecure_path:#Defaults\tsecure_path:g" /etc/sudoers

# Run init.sh script while running docker container
COPY init.sh /
CMD /init.sh
