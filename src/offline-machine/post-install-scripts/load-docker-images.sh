#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

docker_images_path="$root_dir/docker-images"
if [ -d "$docker_images_path" ]; then
	for image_path in $docker_images_path/*.tar.gz; do
		echo "Loading image, $image_path..."
		docker image load < $image_path | gzip --decompress --stdout
	done
else
	echo "Skipping Docker image loading; path not found, $docker_images_path."
fi
