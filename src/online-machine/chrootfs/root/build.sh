#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
scripts_dir="$base_dir/scripts"

if [ ! -d "$scripts_dir" ]; then
	echo >&2 "Cannot find the scripts root folder, $scripts_dir."
	exit 1
fi

script_filenames=( "prepare-environment.sh" "get-packages.sh" )
for script_filename in "${script_filenames[@]}"; do
	script_path="$base_dir/scripts/$script_filename"
	if [ -f "$script_path" ]; then
		bash $script_path
	else
		echo >&2 "Cannot find the script, $script_path."
	fi
done
