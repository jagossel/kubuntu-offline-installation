#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

preferences_dir="$root_dir/preferences.d"
[ -d "$preferences_dir" ] && rm $preferences_dir -Rf

mkdir -p $preferences_dir

preferences_source_dir="$chroot_dir/etc/apt/preferences.d"
cp $preferences_source_dir/* $preferences_dir -Rf
