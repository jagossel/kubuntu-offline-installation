#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

packages_dir="$root_dir/packages"
if [ ! -d "$packages_dir" ]; then
	echo >&2 "Cannot find the packages directory, $packages_dir"
	exit 1
fi

packages_index_path="$packages_dir/Packages.gz"

packages_md5hash="$( md5sum $packages_index_path | awk '{print $1}' )"
packages_sha256hash="$( sha256sum $packages_index_path | awk '{print $1}' )"

release_file_path="$packages_dir/Release"
[ -f $release_file_path ] && rm $release_file_path -f

echo "Generating the $release_file_path..."
echo "Origin: Local Repository" > $release_file_path
echo "Label: Local Repository" >> $release_file_path
echo "Suite: unstable" >> $release_file_path
echo "Codename: noble" >> $release_file_path
echo "Architectures: amd64" >> $release_file_path
echo "Components: offline" >> $release_file_path
echo "Description: A local repository for offline installation of packages." >> $release_file_path
echo "MD5Sum:" >> $release_file_path
echo " $packages_md5hash" >> $release_file_path
echo "SHA256:" >> $release_file_path
echo " $packages_sha256hash" >> $release_file_path
