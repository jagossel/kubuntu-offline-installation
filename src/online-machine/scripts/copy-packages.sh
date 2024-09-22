#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

packages_dir="$root_dir/packages"
[ -d "$packages_dir" ] && rm $packages_dir -Rfv

mkdir -pv $packages_dir

packages_source_dir="$chroot_dir/var/cache/apt/archives"
cp $packages_source_dir/* $packages_dir -Rfv
