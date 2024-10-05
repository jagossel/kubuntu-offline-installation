#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

mount --bind /dev $chroot_dir/dev
mount --bind /dev/pts $chroot_dir/dev/pts
mount -t proc /proc $chroot_dir/proc
mount -t sysfs /sys $chroot_dir/sys
mount --bind /run $chroot_dir/run
mount --bind /tmp $chroot_dir/tmp

chroot $chroot_dir /bin/bash /root/build.sh

umount -R $chroot_dir/{tmp,run,sys,proc,dev}
