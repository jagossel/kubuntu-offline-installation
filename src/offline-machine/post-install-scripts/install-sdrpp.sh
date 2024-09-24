#!/bin/bash

local_repo_path="/usr/share/repos/local"
if [ ! -d "$local_repo_path" ]; then
	echo >&2 "Cannot find the path, $local_repo_path."
	exit 1
fi

sdrpp_package_path="$local_repo_path/sdrpp_ubuntu_noble_amd64.deb"
if [ ! -f "" ]; then
	echo >&2 "Cannot find the path, $sdrpp_package_path."
fi

dpkg --install $sdrpp_package_path
apt-get --fix-broken -y install
