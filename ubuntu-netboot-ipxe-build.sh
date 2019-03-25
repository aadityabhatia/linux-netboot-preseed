# build iPXE image for network boot

apt-get install -y build-essential liblzma-dev
git clone http://git.ipxe.org/ipxe.git
cd ipxe/src/

## enable HTTPS and image verification features
sed -i '/DOWNLOAD_PROTO_HTTPS/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/IMAGE_TRUST_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h

## fetch iPXE menu interface
wget https://gist.githubusercontent.com/aadityabhatia/3c6da3cc3ee5e607a1851ea709fe8c65/raw/menu.ipxe
make bin/ipxe.kpxe bin-x86_64-efi/ipxe.efi EMBED=menu.ipxe
OUTPUT=$(mktemp -d)
mv -v bin/ipxe.kpxe bin-x86_64-efi/ipxe.efi $OUTPUT
echo Build output: $OUTPUT

# tftp server

## install node.js or use another program to serve ipxe.kpxe over tftp; place the image on router if supported
apt install tftpd-hpa
mv $OUTPUT/* /var/lib/tftpboot/

## configure router DHCP boot image parameter, https://wiki.dd-wrt.com/wiki/index.php/PXE
## in case of DNSMasq: dhcp-boot=ipxe.efi,blowfish,192.168.1.2

# netboot server - optional

mkdir netboot
cd netboot

## fetch and extract netboot image
wget http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar zxf netboot.tar.gz
cd ..

## serve locally over http
python3 -m http.server

# preseed

## install and run preseed generator
npm install --global preseed
preseed
