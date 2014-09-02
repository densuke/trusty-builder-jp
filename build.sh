#!/bin/bash

# output image
IMAGE=binary.hybrid.iso 

# workdir
WORK=/builder

# image(iso) output dir
DEST=/target

# work area size(ISO+work). Default; more than 7.5G
SIZE=$[75*1024*1024/10]

# if system has ionice, use idle building
IONICE=`which ionice`

cd ${WORK}/config
debuild
cd ${DEST}
REMAIN=$(df . | tail -n +2 | awk '{print $4}')
if [ $REMAIN -lt $SIZE ]; then
 cat <<EOM
===== unable to create image =====
target volume need space more then 8G.
Aborted
EOM
 exit 1
fi

BUILDER=ubuntu-defaults-image
if [ ! "x${IONICE}" = "x" ]; then echo "use ionice"; BUILDER="ionice -c3 ${BUILDER}"; fi
if [ ! "x${http_proxy}" = "x" ]; then echo "use proxy ${http_proxy}"; fi

WORKDIR=build.${RANDOM}
mkdir ${DEST}/${WORKDIR} && cd ${DEST}/${WORKDIR}
trap "cd ${DEST}; rm -fr ${DEST}/${WORKDIR}" 0
set -x
http_proxy=${http_proxy} nice ${BUILDER} --package ${WORK}/*.deb --components main,restricted,universe,multiverse --ppa japaneseteam/ppa
[ -f ${IMAGE} ] && mv -v ${IMAGE} ${DEST}/ 
