#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

sources_dir="$root_dir/sources.list.d"
[ -d "$sources_dir" ] && rm $sources_dir -Rf

mkdir -p $sources_dir

sources_source_dir="$chroot_dir/etc/apt/sources.list.d"
cp $sources_source_dir/* $sources_dir -Rf
