#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
script_root_dir=$( dirname $base_dir )
src_dir=$( dirname $script_root_dir )
root_dir=$( dirname $src_dir )

preferences_path="/etc/apt/preferences.d"
[ -d "$preferences_path" ] || mkdir -pv $preferences_path

additional_preferences_path="$root_dir/preferences.d"
if [ -d $additional_preferences_path ]; then
	echo "Copying preferences..."
	cp $additional_preferences_path/* $preferences_path -Rf
fi
