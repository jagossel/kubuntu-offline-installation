bail() {
	echo >&2 "$@"
	exit 1
}

baseDir=$( dirname "$( readlink -f $0 )" )
srcRootDir=$( dirname $baseDir )
rootDir=$( dirname $srcRootDir )
packagesDir="$rootDir/packages"
checksumPath="$packagesDir/sha256sum"

[ -d $packagesDir ] || bail "The packages directory does not exist.  Run the prepare-packages.sh script first."
[ -f $checksumPath ] || bail "The checksum file does not exist.  Run the prepare-packages.sh script first."

echo "Verifying packages..."
pushd $packagesDir
while read -r checksum filename; do
	if [ $filename != "sha256sum" ]; then
		if ! echo "$checksum  $filename" | sha256sum --check --status; then
			bail "Chcecksum verifcation failed for $filename"
		fi
	fi
done < "$checksumPath"
popd

echo "All checksums verified successfully."
