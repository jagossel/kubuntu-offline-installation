#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

package_list_path="$src_dir/packages.csv"
if [ ! -f "$package_list_path" ]; then
	echo >&2 "Cannot find the package list, $package_list_path."
	exit 1
fi

cp $package_list_path $chroot_dir/root -f
