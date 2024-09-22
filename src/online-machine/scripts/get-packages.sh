#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

mount --verbose --bind /dev $chroot_dir/dev
mount --verbose --bind /dev/pts $chroot_dir/dev/pts
mount --verbose -t proc /proc $chroot_dir/proc
mount --verbose -t sysfs /sys $chroot_dir/sys
mount --verbose --bind /run $chroot_dir/run
mount --verbose --bind /tmp $chroot_dir/tmp

chroot $chroot_dir bash /root/build.sh

umount --verbose -R $chroot_dir/{tmp,run,sys,proc,dev}
