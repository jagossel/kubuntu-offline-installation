#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

keyrings_dir="$root_dir/keyrings"
[ -d "$keyrings_dir" ] && rm $keyrings_dir -Rf

mkdir -p $keyrings_dir

keyrings_source_dir="$chroot_dir/etc/apt/keyrings"
cp $keyrings_source_dir/* $keyrings_dir -Rf
