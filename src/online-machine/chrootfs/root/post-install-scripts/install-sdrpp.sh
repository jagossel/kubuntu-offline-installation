#!/bin/bash

# SDR++ Installation
wget -O /var/cache/apt/archives/sdrpp_ubuntu_noble_amd64.deb https://github.com/AlexandreRouma/SDRPlusPlus/releases/download/nightly/sdrpp_ubuntu_noble_amd64.deb
if [ -f '/var/cache/apt/archives/sdrpp_ubuntu_noble_amd64.deb' ]; then
	dpkg --install /var/cache/apt/archives/sdrpp_ubuntu_noble_amd64.deb
	apt-get --fix-broken install -y
else
	echo === WARNING! ===
	echo SDR++ did not download, skipping installation.
	echo === WARNING! ===
fi
