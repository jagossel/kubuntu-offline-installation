bail() {
	echo >&2 "$@"
	exit 1
}

base_dir=$( dirname "$( readlink -f $0 )" )
src_root_dir=$( dirname $base_dir )
root_dir=$( dirname $src_root_dir )
packages_dir="$root_dir/packages"
checksum_path="$packages_dir/sha256sum"

[ -d $packages_dir ] || bail "The packages directory does not exist.  Run the prepare-packages.sh script first."
[ -f $checksum_path ] || bail "The checksum file does not exist.  Run the prepare-packages.sh script first."

echo "Verifying packages..."
pushd $packages_dir
while read -r checksum filename; do
	if [ $filename != "sha256sum" ]; then
		if ! echo "$checksum  $filename" | sha256sum --check --status; then
			bail "Chcecksum verifcation failed for $filename"
		fi
	fi
done < "$checksum_path"
popd

echo "All checksums verified successfully."
