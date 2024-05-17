#!/bin/bash

THIS_SCRIPT=$(readlink -f $0)
TOPDIR=$(dirname $(dirname $THIS_SCRIPT))

OE_BRANCH="zeus"
REL_BRANCH="devkit-ex-b0"
BITBAKE_BRANCH="1.44"

# List of layers used to build images
REPO_CONFIG=" \
LAYER;https://git.openembedded.org/openembedded-core.git;branch=$OE_BRANCH \
LAYER;https://$HTTPS_USER:$HTTPS_PASSWD@github.com/alifsemi/meta-alif.git;branch=$REL_BRANCH \
LAYER;https://$HTTPS_USER:$HTTPS_PASSWD@github.com/alifsemi/meta-alif-ensemble.git;branch=$REL_BRANCH \
LAYER;https://$HTTPS_USER:$HTTPS_PASSWD@github.com/alifsemi/meta-alif-iot.git;branch=$REL_BRANCH \
LAYER;https://github.com/lgirdk/meta-yocto.git;branch=$OE_BRANCH \
LAYER;https://git.openembedded.org/meta-openembedded.git;branch=$OE_BRANCH \
BITBAKE;https://git.openembedded.org/bitbake.git;branch=$BITBAKE_BRANCH \
"
for iter in ${REPO_CONFIG} ; do
        BRANCH=$(echo "$iter" | cut -d ";" -f 3 | sed "s:branch=::g")
        URL=$(echo "$iter" | cut -d ";" -f 2)
        SOURCE_NAME=$(echo $URL | grep -o "[^/]*$" | sed "s:\.git::g")

        if echo $iter | grep -q "BITBAKE;" ; then
            if [ -d ${TOPDIR}/tools/${SOURCE_NAME} -a "x$1" = "xupdate" ] ; then
                pushd ${TOPDIR}/tools/${SOURCE_NAME}
                git fetch ${BRANCH} ${BRANCH}
                popd
            else
                git clone ${URL} -b ${BRANCH} ${TOPDIR}/tools/${SOURCE_NAME}
            fi
        else
            if [ -d ${TOPDIR}/layers/${SOURCE_NAME} -a "x$1" = "xupdate" ] ; then
                pushd ${TOPDIR}/layers/${SOURCE_NAME} ; git pull ; popd
            else
                git clone ${URL} -b ${BRANCH} ${TOPDIR}/layers/${SOURCE_NAME}
            fi
        fi
done
