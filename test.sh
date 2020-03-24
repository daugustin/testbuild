#!/bin/sh
AUTOBUILD_FILE="$(curl -s http://gentoo.osuosl.org/releases/amd64/autobuilds/latest-stage4-amd64-minimal.txt | tail -n1 | awk '{print $1}')"
AUTOBUILD_DL="http://gentoo.osuosl.org/releases/amd64/autobuilds/${AUTOBUILD_FILE}"
AUTOBUILD_FILENAME="$(echo $AUTOBUILD_FILE | xargs basename)"
TEMPDIR="$(mktemp -d)"
BASEDIR="$(pwd)"
env
cd "${TEMPDIR}"
wget -nv "${AUTOBUILD_DL}"
mkdir mnt
fallocate -l 10G image
DEVICE=$(losetup -f --show image)
parted -s "${DEVICE}" mklabel gpt
parted -s --align=none "${DEVICE}" mkpart bios_boot 0 2M
parted -s --align=none "${DEVICE}" mkpart primary 2M 100%
parted -s "${DEVICE}" set 1 boot on
parted -s "${DEVICE}" set 1 bios_grub on
mkfs.ext4 -m0 "${DEVICE}"p2
e2label "${DEVICE}"p2 cloudimg-rootfs
mount "${DEVICE}"p2 mnt
tar --xattrs -xpf "${AUTOBUILD_FILENAME}" -C mnt
umount mnt
rmdir mnt
mv image $BASEDIR
cd $BASEDIR
bzip2 image
