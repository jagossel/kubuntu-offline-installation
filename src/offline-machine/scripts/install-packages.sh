#!/bin/bash

if [ -z "$1" ]; then
	echo >&2 "The profile name is required."
	exit 1
fi

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )

package_list_file_path="$src_dir/packages.csv"
if [ ! -f $package_list_file_path ]; then
	echo >&2 "Cannot find the package list file, $package_list_file_path."
	exit 1
fi

apt-get update
apt-get -y upgrade

package_list=$( grep -E ".*,($1|\*)" $package_list_file_path | awk -F, '{ print $1 }' | tr '\n' ' ' )
apt-get -y install $package_list
