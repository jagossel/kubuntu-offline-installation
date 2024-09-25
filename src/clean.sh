#!/bin/bash

base_dir=$( dirname "$( readlink -f $0 )" )
root_dir=$( dirname "$base_dir" )

rm $root_dir/{keyrings,packages,preferences.d,sources.list.d,chroot} -Rfv
