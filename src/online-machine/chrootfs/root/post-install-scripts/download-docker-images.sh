#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
docker_images_path="$base_dir/docker-images.csv"
if [ ! -f "$docker_images_path" ]; then
	echo >&2 "Cannot find the docker images list file, $docker_images_path."
	exit 1
fi

home_dir=$( dirname "$base_dir" )
images_dir="$home_dir/docker-images"
[ -d "$images_dir" ] || mkdir -p $images_dir

grep -E ".*,($1|\*)" $docker_images_path | while IFS= read -r record; do
	image_name=$( echo "$record" | awk -F, '{ print $1 }' )
	image_tag=$( echo "$record" | awk -F, '{ print $2 }' )
	image_file_name=$( echo "$record" | awk -F, '{ print $3 }' )
	image_path="$images_dir/$image_file_name.tar.gz"

	image="$image_name:$image_tag"
	docker pull $image

	echo "Saving image to $image_path..."
	docker image save $image | gzip > "$image_path"
done
