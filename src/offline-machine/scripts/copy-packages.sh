#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )
packages_dir="$root_dir/packages"

verify_packages_script_path="$base_dir/verify-checksums.sh"
if [ ! -f "$verify_packages_script_path" ]; then
	echo >&2 "Cannot find the script, $verify_packages_script_path."
	exit 1
fi

echo "Verifying packages before copying..."
bash $verify_packages_script_path $packages_dir

local_repo_path="/usr/share/repos/local"
[ -d "$local_repo_path" ] || mkdir -pv $local_repo_path

echo "Copying packages to $local_repo_path..."
cp $packages_dir/* $local_repo_path -Rf

echo "Verifying packages after copying..."
bash $verify_packages_script_path $local_repo_path
