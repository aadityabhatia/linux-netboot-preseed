git clone http://git.ipxe.org/ipxe.git
cd ipxe/src/
sed -i '/DOWNLOAD_PROTO_HTTPS/ s/^[^ \t]*[ \t]/#define /' config/general.h
sed -i '/IMAGE_TRUST_CMD/ s/^[^ \t]*[ \t]/#define /' config/general.h
wget https://gist.githubusercontent.com/aadityabhatia/3c6da3cc3ee5e607a1851ea709fe8c65/raw/menu.ipxe
make bin/ipxe.kpxe EMBED=menu.ipxe
