bail() {
	echo >&2 "$@"
	exit 1
}

base_dir=$( dirname "$( readlink -f $0 )" )
src_root_dir=$( dirname $base_dir )
root_dir=$( dirname $src_root_dir )
docker_images_path="$root_dir/docker-images"
checksum_path="$docker_images_path/sha256sum"

[ -d $docker_images_path ] || bail "The Docker images directory does not exist.  Run the prepare-packages.sh script first."
[ -f $checksum_path ] || bail "The checksum file does not exist.  Run the prepare-packages.sh script first."

echo "Verifying Docker Images..."
pushd $docker_images_path
while read -r checksum filename; do
	if [ $filename != "sha256sum" ]; then
		if ! echo "$checksum  $filename" | sha256sum --check --status; then
			bail "Chcecksum verifcation failed for $filename"
		fi
	fi
done < "$checksum_path"
popd

echo "All checksums verified successfully."
