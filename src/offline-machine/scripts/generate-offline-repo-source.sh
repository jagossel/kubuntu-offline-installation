#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

local_repo_path="/usr/share/repos/local"
if [ ! -d "$local_repo_path" ]; then
	echo >&2 "Cannot find the path, $local_repo_path."
	exit 1
fi

echo "Generating repo meta data..."
echo "deb [trusted=yes] file:$local_repo_path ./" > /etc/apt/sources.list.d/offline.list
