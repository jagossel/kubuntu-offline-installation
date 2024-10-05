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

pushd $packages_dir
sha256sum * > sha256sum
popd

docker_images_path="$root_dir/docker-images"
if [ -d "$docker_images_path" ]; then
	pushd $docker_images_path
	sha256sum * > sha256sum
	pushd
else
	echo "Skipping docker image; cannot find the path, $docker_images_path."
fi
