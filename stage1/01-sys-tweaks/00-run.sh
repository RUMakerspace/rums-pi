#!/bin/bash -e

OHMYZSH="/usr/share/ohmyzsh"

install -d "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d"
install -m 644 files/noclear.conf "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/noclear.conf"
install -v -m 644 files/fstab "${ROOTFS_DIR}/etc/fstab"

echo "Installing ohmyzsh..."
on_chroot << EOF
git clone https://github.com/ohmyzsh/ohmyzsh.git ${OHMYZSH}
EOF

install -m 644 files/zshrc "${ROOTFS_DIR}/${OHMYZSH}/zshrc"

on_chroot << EOF
ln ${OHMYZSH}/zshrc /etc/skel/.zshrc
EOF

on_chroot << EOF
if ! id -u ${FIRST_USER_NAME} >/dev/null 2>&1; then
	adduser --disabled-password --gecos "" ${FIRST_USER_NAME}
fi
chsh -s $(which zsh) root
echo "${FIRST_USER_NAME}:${FIRST_USER_PASS}" | chpasswd
echo "root:root" | chpasswd
EOF


