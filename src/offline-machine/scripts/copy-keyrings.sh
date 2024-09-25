#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

keyrings_path="/etc/apt/keyrings"
[ -d $keyrings_path ] || install -d -m 0755 /etc/apt/keyrings

source_keyrings_path="$root_dir/keyrings"
if [ -d $source_keyrings_path ]; then
	echo "Copying keyrings..."
	cp $source_keyrings_path/* $keyrings_path -Rf
fi
