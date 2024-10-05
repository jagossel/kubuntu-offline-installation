#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

docker_images_path="$root_dir/docker-images"
checksum_path="$docker_images_path/sha256sum"
if [ -d "$docker_images_path" ]; then
	if [ -f "$checksum_path" ]; then
		pushd $docker_images_path
		while read -r checksum filename; do
			if [ $filename != "sha256sum" ]; then
				if ! echo "$checksum  $filename" | sha256sum --check --status; then
					bail "Chcecksum verifcation failed for $filename"
				fi
			fi
		done < "$checksum_path"
		popd
	else
		echo "Skipping checksum verification; path not found, $checksum_path."
	fi

	for image_path in $docker_images_path/*.tar.gz; do
		echo "Loading image, $image_path..."
		docker image load < $image_path | gzip --decompress --stdout
	done
else
	echo "Skipping Docker image loading; path not found, $docker_images_path."
fi
