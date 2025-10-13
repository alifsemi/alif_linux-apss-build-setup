#!/bin/bash

export -n BBPATH
if [ -n "$BASH_SOURCE" ]; then
   THIS_SCRIPT=$BASH_SOURCE
elif [ -n "$ZSH_NAME" ]; then
   THIS_SCRIPT=$0
else
   THIS_SCRIPT="$(pwd)/setup.sh"
fi
if [ -z "$ZSH_NAME" ] && [ "$0" = "$THIS_SCRIPT" ]; then
   EXIT="exit"
else
   EXIT="return"
fi
export PATH=$PATH
THIS_SCRIPT=$(readlink -f $THIS_SCRIPT)
TOPDIR=$(dirname $THIS_SCRIPT)/../

if [ -e ~/.windows_docker -a "x$1" = "x" ] ; then
   BUILD_DIR=~/build
   echo "$BUILD_DIR used as project." 2>&1
   echo "To change run source ${THIS_SCRIPT} <builddir>" 2>&1
elif [ -e ~/.windows_docker -a "x$1" != "x" ] ; then
   BUILD_DIR=~/$(basename $1)
   echo "$BUILD_DIR used as project." 2>&1
   echo "To change run source ${THIS_SCRIPT} <builddir>" 2>&1
elif [ "x$1" = "x" ] ; then
   BUILD_DIR=$TOPDIR/build
   echo "$BUILD_DIR used as project." 2>&1
   echo "To change run source ${THIS_SCRIPT} <builddir>" 2>&1
else
   BUILD_DIR=$(readlink -f $1)
fi


BITBAKE="$TOPDIR/tools/bitbake"

if [ ! -d "$BITBAKE" ] ; then
   echo "Unable to find $BITBAKE directory"
   $EXIT 1
fi

export BITBAKEDIR=$TOPDIR/tools/bitbake

# Add base OE-core layer
source ${TOPDIR}/layers/openembedded-core/oe-init-build-env ${BUILD_DIR}

# Use custom local.conf from meta-alif
LOCALCONF="$(readlink -f conf/local.conf)"
OELOCALSAMPLE="${TOPDIR}/layers/openembedded-core/meta/conf/templates/default/local.conf.sample"
ALIFLOCALSAMPLE="${TOPDIR}/layers/meta-alif-ensemble/conf/local.conf.sample"
if diff -q $LOCALCONF $OELOCALSAMPLE ; then
   cp -f $ALIFLOCALSAMPLE $LOCALCONF
fi
unset LOCALCONF OELOCALSAMPLE ALIFLOCALSAMPLE

# Add dependent layers
LAYERS="meta-alif  \
meta-alif-ensemble \
meta-openembedded/meta-oe \
meta-openembedded/meta-python \
meta-openembedded/meta-networking \
meta-openembedded/meta-filesystems \
meta-yocto/meta-poky"

for iter in ${LAYERS} ; do
   if [ ! -f "${BUILD_DIR}/.${iter///}" ] ; then
      bitbake-layers add-layer ${TOPDIR}/layers/$iter
      if [ $? -eq 0 ] ; then touch ${BUILD_DIR}/.${iter///} ; fi
   fi
done

if [ ! -f "conf/auto.conf" ] ; then
   echo "MACHINE=\"devkit-e8\"" > conf/auto.conf
   echo "DISTRO=\"apss-tiny\""  >> conf/auto.conf
   if [ "x$SOURCE_MIRROR_URL" = "x" ] ; then
      echo "SOURCE_MIRROR_URL=\"https://downloads.yoctoproject.org/mirror/sources/\"" >> conf/auto.conf
   fi
   echo "TFA_BRANCH=\"alif_lts-v2.10.8\"" >> conf/auto.conf
   echo "ALIF_KERNEL_BRANCH=\"v6.12-dev\"" >> conf/auto.conf
   echo "LINUX_DD_TC_BRANCH=\"scarthgap\"" >> conf/auto.conf
   echo "TFA_TREE=\"git://github.com/alifsemi/trusted-firmware-a_alif;protocol=https\"" >> conf/auto.conf
   echo "ALIF_KERNEL_TREE=\"git://github.com/alifsemi/linux_alif;protocol=https\"" >> conf/auto.conf
   echo "LINUX_DD_TC_TREE=\"git://github.com/alifsemi/alif_a32_linux_DD_testcases;protocol=https\"" >> conf/auto.conf
   if [ "x$REL_TAG" != "x" ] ; then
       echo "SRCREV:pn-linux-alif=\"$REL_TAG\"" >> conf/auto.conf
       echo "SRCREV:pn-trusted-firmware-a=\"$REL_TAG\"" >> conf/auto.conf
   fi
fi

# Temporary waiting for proper bitbake integration: https://patchwork.openembedded.org/patch/144806/
#RELPATH=$(python -c "from os.path import relpath; print (relpath(\"$TOPDIR/layers\",\"$(pwd)\"))")
#sed -i conf/bblayers.conf -e "s,$TOPDIR/layers/,\${TOPDIR}/$RELPATH/,"

if [ "$(readlink -f setup.sh)" = "$(readlink -f $TOPDIR/setup.sh)" ] ; then
   echo "Something went wrong. Exiting to prevent overwritting setup.sh"
   $EXIT 1
fi
SCRIPT_RELPATH=$(python3 -c "from os.path import relpath; print (relpath(\"$TOPDIR\",\"`pwd`\"))")
cat > setup.sh << EOF
#!/bin/bash
if [ -n "\$BASH_SOURCE" ]; then
   THIS_SCRIPT=\$BASH_SOURCE
elif [ -n "\$ZSH_NAME" ]; then
   THIS_SCRIPT=\$0
else
   THIS_SCRIPT="\$(pwd)/setup.sh"
fi
PROJECT_DIR=\$(dirname \$(readlink -f \$THIS_SCRIPT))
cd \$PROJECT_DIR
export LANG="en_US.UTF-8"
export BITBAKEDIR=$SCRIPT_RELPATH/tools/bitbake
source $SCRIPT_RELPATH/layers/openembedded-core/oe-init-build-env \$PROJECT_DIR
EOF


if [ "$EXIT" = "exit" ] ; then
   echo
   echo "=Setup Complete="
   echo
   echo "* Run the following to start building with your project:"
   echo "source $BUILD_DIR/setup.sh"
   echo "bitbake alif-helloworld-image"
   echo "bitbake alif-tiny-image"
   echo
else
   echo
   echo "=Setup Complete="
   echo
   echo "* Run the following to start building with your project:"
   echo "bitbake alif-helloworld-image"
   echo "bitbake alif-tiny-image"
   echo
fi
