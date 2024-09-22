#!/bin/bash

if [ -z "$1" ]; then
	echo >&2 "The profile name is required."
	exit 1
fi

verify_checksums() {
	while read -r checksum filename; do
		if [ $filename != "sha256sum" ]; then
			if ! echo "$checksum  $filename" | sha256sum --check --status; then
				echo >&2 "Checksum verification failed for $filename"
				exit 1
			fi
		fi
	done < "sha256sum"

	echo "All checksums verified successfully."
}

base_dir=$( dirname "$( readlink -f $0 )" )
src_root_dir=$( dirname $base_dir )
root_dir=$( dirname $src_root_dir )
packages_dir="$root_dir/packages"

package_list_file_path="$src_root_dir/packages.csv"
if [ ! -f $package_list_file_path ]; then
	echo >&2 "Cannot find the package list file, $package_list_file_path."
	exit 1
fi

local_repo_path="/usr/share/repos/local-repo"
[ -d $local_repo_path ] || mkdir -p $local_repo_path

echo "Verifying packages before copying..."
pushd $packages_dir
verify_checksums
popd

echo "Copying packages to $local_repo_path..."
cp $packages_dir/* $local_repo_path -Rf

echo "Verifying packages after copying..."
pushd $local_repo_path
verify_checksums
popd

keyrings_path="/etc/apt/keyrings"
[ -d $keyrings_path ] || install -d -m 0755 /etc/apt/keyrings

source_keyrings_path="$root_dir/keyrings"
if [ -d $source_keyrings_path ]; then
	echo "Copying keyrings..."
	cp $source_keyrings_path/* $keyrings_path -Rf
fi

source_list_path="/etc/apt/sources.list.d"
[ -d $source_list_path ] || mkdir -p $source_list_path

additional_sources_path="$root_dir/sources.list.d"
if [ -d $additional_sources_path ]; then
	echo "Copying additional repo sources..."
	cp $additional_sources_path/* $source_list_path -Rf
fi

preferences_path="/etc/apt/preferences.d"

additional_preferences_path="$rootDir/preferences.d"
if [ -d $additional_preferences_path ]; then
	echo "Copying preferences..."
	cp $additional_preferences_path $preferences_path -Rf
fi

echo "Generating repo meta data..."
echo "deb [trusted=yes] file:$local_repo_path ./" > /etc/apt/sources.list.d/offline.list

apt-get update
apt-get -y upgrade

package_list=$( grep -E ".*,($1|\*)" $package_list_file_path | awk -F, '{ print $1 }' | tr '\n' ' ' )
apt-get -y install $package_list

# Install SDR++
dpkg --install $local_repo_path/sdrpp_ubuntu_noble_amd64.deb
apt-get --fix-broken -y install

qdbus org.kde.Shutdown /Shutdown logoutAndReboot
