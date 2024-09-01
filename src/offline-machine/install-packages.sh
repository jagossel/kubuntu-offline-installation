#!/bin/bash

bail() {
	echo >&2 "$@"
	exit 1
}

baseDir=$( dirname "$( readlink -f $0 )" )
srcRootDir=$( dirname $baseDir )
rootDir=$( dirname $srcRootDir )
packagesDir="$rootDir/packages"

packageListFilePath="$srcRootDir/packages-core.txt"
[ -f $packageListFilePath ] || bail "Cannot find the package list file, $packageListFilePath."

localRepoPath="/usr/share/repos/local-repo"
[ -d $localRepoPath ] || mkdir -p $localRepoPath

echo "Copying packages to $localRepoPath..."
cp $packagesDir/* $localRepoPath -Rf

echo "Generating repo meta data..."
echo "deb [trusted=yes] file:$localRepoPath ./" > /etc/apt/sources.list.d/offline.list

apt-get update
apt-get -y upgrade

packageList="$( grep ".*" $packageListFilePath|tr '\n' ' ' )"
apt-get -y install $packageList

qdbus org.kde.Shutdown /Shutdown logoutAndReboot
