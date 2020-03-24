#!/bin/sh
echo foo
sudo whoami
AUTOBUILD_FILE="$(curl -s http://gentoo.osuosl.org/releases/amd64/autobuilds/latest-stage4-amd64-minimal.txt | tail -n1 | awk '{print $1}')"
AUTOBUILD_DL="http://gentoo.osuosl.org/releases/amd64/autobuilds/${AUTOBUILD_FILE}"
AUTOBUILD_FILENAME="$(echo $AUTOBUILD_FILE | xargs basename)"
TEMPDIR="$(mktemp -d)"
cd "${TEMPDIR}"
wget -nv "${AUTOBUILD_DL}"
