#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

source_list_path="/etc/apt/sources.list.d"
[ -d $source_list_path ] || mkdir -p $source_list_path

additional_sources_path="$root_dir/sources.list.d"
if [ -d $additional_sources_path ]; then
	echo "Copying additional repo sources..."
	cp $additional_sources_path/* $source_list_path -Rf
fi
