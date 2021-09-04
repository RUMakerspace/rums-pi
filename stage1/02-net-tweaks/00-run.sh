#!/bin/bash -e

echo "${TARGET_HOSTNAME}" > "${ROOTFS_DIR}/etc/hostname"
echo "127.0.1.1		${TARGET_HOSTNAME}" >> "${ROOTFS_DIR}/etc/hosts"

install -m 644 files/00-wired.network "${ROOTFS_DIR}/etc/systemd/network/00-wired.network"
install -m 644 files/10-wireless.network "${ROOTFS_DIR}/etc/systemd/network/10-wireless.network"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"
