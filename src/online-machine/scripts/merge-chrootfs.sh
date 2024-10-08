#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chrootfs_dir="$script_root_dir/chrootfs"
if [ ! -d "$chrootfs_dir" ]; then
	echo >&2 "Cannot find the chrootfs files, $chrootfs_dir."
	exit 1
fi

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot folder, $chroot_dir."
	exit 1
fi

cp $chrootfs_dir/* $chroot_dir -Rf
