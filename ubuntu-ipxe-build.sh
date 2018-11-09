# build iPXE image for network boot

git clone http://git.ipxe.org/ipxe.git
mkdir tftp # output directory
cd ipxe/src/

## enable HTTPS and image verification features
sed -i '/DOWNLOAD_PROTO_HTTPS/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/IMAGE_TRUST_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h

## fetch iPXE menu interface
wget https://gist.githubusercontent.com/aadityabhatia/3c6da3cc3ee5e607a1851ea709fe8c65/raw/c06f59eafea06d605dc720774537378cbcf248fe/menu.ipxe
make bin/ipxe.kpxe EMBED=menu.ipxe
cd ../..
mv ipxe/src/bin/ipxe.kpxe tftp/

# tftp server

## install node.js or use another program to serve ipxe.kpxe over tftp; place the image on router if supported
curl -sL https://deb.nodesource.com/gpgkey/nodesource.gpg.key -o /etc/apt/trusted.gpg.d/nodesource.asc
echo "deb http://deb.nodesource.com/node_10.x $(lsb_release -sc) main" > /etc/apt/sources.list.d/nodesource.list
apt-get update
apt-get -y install nodejs
npm install --global tftp
ntftp 0.0.0.0 -l tftp/

## TODO: configure router DHCP boot image parameter, https://wiki.dd-wrt.com/wiki/index.php/PXE
## in case of DNSMasq: dhcp-boot=ipxe.kpxe,blowfish,192.168.1.2

# netboot server

mkdir netboot
cd netboot

## fetch and extract netboot image
wget http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/netboot.tar.gz
tar zxf netboot.tar.gz

## fetch and update preseed file
wget https://gist.githubusercontent.com/aadityabhatia/0ec8f9016e1cc1e2583804d17b9e6629/raw/5780d67fb415474ab402de8e215431596d871e90/preseed.cfg

## serve locally over http
python3 -m http.server