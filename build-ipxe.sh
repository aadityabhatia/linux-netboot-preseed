#!/bin/bash
set -ve

# apt install liblzma-dev

menu=$(readlink -e menu.ipxe)
pwd=$(pwd)

BUILD_OUTPUT="bin/ipxe.usb bin/ipxe.iso bin/undionly.kpxe bin-x86_64-efi/ipxe.efi"

cd /usr/local/src/
test -d ipxe && (cd ipxe && git pull) || git clone https://github.com/ipxe/ipxe.git
cd ipxe/src/
sed -i '/DOWNLOAD_PROTO_HTTPS/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/IMAGE_TRUST_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/NET_PROTO_IPV6/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/NTP_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h
make $BUILD_OUTPUT EMBED=$menu
mv -v $BUILD_OUTPUT $pwd
