The following provides a general outline for setting up [PXE boot](https://en.wikipedia.org/wiki/Preboot_Execution_Environment) for Debian/Ubuntu [network installation](https://help.ubuntu.com/community/Installation/Netboot) using a [preconfiguration file](https://help.ubuntu.com/lts/installation-guide/amd64/apbs01.html).

- build [iPXE firmware image](https://ipxe.org/) with an embedded [customized menu file](https://gist.githubusercontent.com/aadityabhatia/3c6da3cc3ee5e607a1851ea709fe8c65/raw/menu.ipxe)
- setup [tftp](https://help.ubuntu.com/community/TFTP) to serve the iPXE image
- *optionally*, serve netboot files locally over HTTP
- setup [preseed server](https://github.com/aadityabhatia/preseed)
