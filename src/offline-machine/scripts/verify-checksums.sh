#!/bin/bash

if [ -z "$1" ]; then
	echo >&2 "The path to the directory to verify the checksums is required."
	exit 1
fi

pushd $1
while read -r checksum filename; do
	if [ $filename != "sha256sum" ]; then
		if ! echo "$checksum  $filename" | sha256sum --check --status; then
			echo >&2 "Checksum verification failed for $filename"
			exit 1
		fi
	fi
done < "sha256sum"

echo "All checksums verified successfully."
popd
