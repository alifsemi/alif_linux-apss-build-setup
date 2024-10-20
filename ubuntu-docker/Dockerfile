FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive

# Install dependent packages
RUN apt-get -y update
RUN apt-get install -y gawk wget git diffstat unzip texinfo gcc build-essential chrpath socat cpio python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 python3-subunit zstd liblz4-tool file locales libacl1 screen sudo minicom curl python3-serial nfs-kernel-server python3-tk libserial-dev tftpd-hpa

RUN pip3 install pyserial keyboard pylink

# Generate and set locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# Make sure /bin/sh points to bash
RUN ln -sf bash /bin/sh

# Run init.sh script while running docker container
COPY init.sh /
CMD /init.sh
