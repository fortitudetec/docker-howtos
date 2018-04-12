#!/bin/bash
set -e
set +x
if [ -z "${VOLUME_ROOT}" ] ; then
  echo "VOLUME_ROOT ENV not suppiled."
  exit 1
fi
/copy-root.sh ${VOLUME_ROOT}
mount -o bind /dev ${VOLUME_ROOT}/dev
mount -o bind,ptmxmode=0666 /dev/pts ${VOLUME_ROOT}/dev/pts
mount -o bind /proc ${VOLUME_ROOT}/proc
mount -o bind /sys ${VOLUME_ROOT}/sys
mount -o bind /etc/resolv.conf ${VOLUME_ROOT}/etc/resolv.conf
mount -o bind /etc/hosts ${VOLUME_ROOT}/etc/hosts
mount -o bind /etc/hostname ${VOLUME_ROOT}/etc/hostname
cp /boot_chrooted.sh ${VOLUME_ROOT}
exec -a init chroot ${VOLUME_ROOT} /boot_chrooted.sh
