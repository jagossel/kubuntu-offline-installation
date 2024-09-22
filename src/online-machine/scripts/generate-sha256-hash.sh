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
