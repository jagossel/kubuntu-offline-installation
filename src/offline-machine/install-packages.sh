#!/bin/bash

if [ -z "$1" ]; then
	echo >&2 "The profile name is required."
	exit 1
fi

base_dir=$( dirname "$( readlink -f $0 )" )

script_filenames=( \
	"copy-packages.sh" \
	"copy-keyrings.sh" \
	"copy-apt-sources.sh" \
	"copy-preferences.sh" \
	"generate-offline-repo-source.sh" \
	"install-packages.sh" \
)

for script_filename in "${script_filenames[@]}"; do
	script_path="$base_dir/scripts/$script_filename"
	if [ -f "$script_path" ]; then
		bash $script_path $1
	else
		echo >&2 "Cannot find the script, $script_path."
		exit 1
	fi
done

post_install_scripts_path="$base_dir/post-install-scripts.csv"
if [ -f "$post_install_scripts_path" ]; then
	grep -E ".*,($1|\*)" $post_install_scripts_path | while IFS= read -r record; do
		post_install_script_filename=$( echo "$record" | awk -F, '{ print $1 }' )
		post_install_script_path="$base_dir/post-install-scripts/$post_install_script_filename"
		if [ -f "$post_install_script_path" ]; then
			bash $post_install_script_path
		else
			echo "Skipping over $post_install_script_path: file not found."
		fi
	done
else
	echo "Skipping over the pre-installation scripts; cannot find the path, $post_install_scripts_path."
fi

qdbus org.kde.Shutdown /Shutdown logoutAndReboot
