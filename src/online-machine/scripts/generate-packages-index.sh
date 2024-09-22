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

packages_index_path="$packages_dir/Packages"
dpkg-scanpackages $packages_dir > $packages_index_path
sed -i "s|$packages_dir||g" $packages_index_path

package_index_compressed_path="$packages_index_path.gz"
gzip -9c $packages_index_path > $package_index_compressed_path
rm $packages_index_path
