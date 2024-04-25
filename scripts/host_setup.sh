#!/bin/bash
: '
version: v0.5
Help:
Run with sudo.
e.g.: sudo ./host_setup.sh
'
: '
Installs necessary packages to build images
using APSS Linux project.
'

if [ "$(whoami)" != "root" ] ; then
    echo "Run with sudo:"
    echo "e.g.: sudo ./host_setup.sh"
    exit 1
fi

sudo apt-get -y update
sudo apt-get install -y gawk wget git-core diffstat unzip texinfo gcc-multilib build-essential chrpath socat cpio python python3 python3-pip python3-pexpect xz-utils debianutils iputils-ping python3-git python3-jinja2 libegl1-mesa libsdl1.2-dev pylint3 xterm libssl-dev vim bash-completion locales screen sudo minicom curl python3-serial nfs-kernel-server python3-tk libserial-dev tftpd-hpa

sudo pip3 install pyserial keyboard pylink

sudo sed -i "s:^Defaults\tsecure_path:#Defaults\tsecure_path:g" /etc/sudoers

sudo locale-gen en_US.UTF-8
LANG="en_US.UTF-8"

sudo ln -sf bash /bin/sh

