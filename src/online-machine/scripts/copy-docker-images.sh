#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

chroot_dir="$root_dir/chroot"
if [ ! -d "$chroot_dir" ]; then
	echo >&2 "Cannot find the chroot, $chroot_dir."
fi

docker_images_path="$root_dir/docker-images"
[ -d "$docker_images_path" ] && rm $docker_images_path -Rf

mkdir -p $docker_images_path

images_source_path="$chroot_dir/root/docker-images"
cp $images_source_path/* $docker_images_path -Rf
