#!/usr/bin/env sh
ABS_DOCKER_DIR=$(dirname $(dirname $(readlink -f $0)))
DISTRO="ubuntu"
VERSION="18.04"
IMAGE="apss/$DISTRO-builder:v$VERSION"
ARCH="$(uname -m)"

# build docker image with the required username
if [ "$ARCH" = "arm64" ] ; then
    sudo docker build -t $IMAGE -f $ABS_DOCKER_DIR/mac-docker/Dockerfile.$ARCH $ABS_DOCKER_DIR
else
    sudo docker build -t $IMAGE -f $ABS_DOCKER_DIR/mac-docker/Dockerfile $ABS_DOCKER_DIR
fi
