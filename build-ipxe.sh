#!/bin/bash
set -ve

# apt install liblzma-dev

menu=$(readlink -e menu.ipxe)
pwd=$(pwd)

cd /usr/local/src/
test -d ipxe && (cd ipxe && git pull) || git clone https://git.ipxe.org/ipxe.git
cd ipxe/src/
sed -i '/DOWNLOAD_PROTO_HTTPS/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/IMAGE_TRUST_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h
make bin/undionly.kpxe bin-x86_64-efi/ipxe.efi EMBED=$menu
mv -v bin/undionly.kpxe bin-x86_64-efi/ipxe.efi $pwd
