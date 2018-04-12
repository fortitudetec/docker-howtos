#!/bin/bash
set -e
set +x

if [ -z "$1" ] ; then
  echo "Dest dir not suppiled."
  exit 1
fi

if [ ! -d "$1" ] ; then
  echo "Dest dir $1 does not exist."
  exit 1
fi

VOLUME_CHROOT_INSTALL_DIR="$1"
if [ -f ${VOLUME_CHROOT_INSTALL_DIR}/.setup ] ; then
  exit 0
fi

# Install current image into volume
rsync --exclude '/dev/*' --exclude '/proc/*' --exclude '/sys/*' --exclude "${VOLUME_CHROOT_INSTALL_DIR}/*" -a / ${VOLUME_CHROOT_INSTALL_DIR}
cd ${VOLUME_CHROOT_INSTALL_DIR}

# Remove speical directories and files
rm -rf dev proc sys etc/resolv.conf etc/hosts etc/hostname

# Create dirs so that bind can mount during runtime
mkdir -p dev proc sys

# Touch these files so that a bind mount can work
touch etc/resolv.conf etc/hosts etc/hostname
touch ${VOLUME_CHROOT_INSTALL_DIR}/.setup
