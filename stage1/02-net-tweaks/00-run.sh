#!/bin/bash -e

echo "${TARGET_HOSTNAME}" > "${ROOTFS_DIR}/etc/hostname"
echo "127.0.1.1		${TARGET_HOSTNAME}" >> "${ROOTFS_DIR}/etc/hosts"

install -m 644 files/00-wired.network "${ROOTFS_DIR}/etc/systemd/network/00-wired.network"
install -m 644 files/10-wireless.network "${ROOTFS_DIR}/etc/systemd/network/10-wireless.network"

ln -sf /dev/null "${ROOTFS_DIR}/etc/systemd/network/99-default.link"

echo "Uninstall classic networking..."
on_chroot << EOF
systemctl disable --now ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog
apt --autoremove purge ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common rsyslog
rm -r /etc/network /etc/dhcp
EOF

echo "Setup/enable systemd-networkd and systemd-resolved..."
on_chroot << EOF
systemctl disable --now libnss-mdns
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
apt-mark hold avahi-daemon ifupdown dhcpcd5 isc-dhcp-client isc-dhcp-common lbnss-mdns openresolv raspberrypi-net-mods rsyslog
systemctl enable --now systemctl-networkd systemd-resolved
EOF
