#!/bin/bash

bail() {
	echo >&2 "$@"
	exit 1
}

verifyChecksums() {
	while read -r checksum filename; do
		if [ $filename != "sha256sum" ]; then
			if ! echo "$checksum  $filename" | sha256sum --check --status; then
				bail "Chcecksum verifcation failed for $filename"
			fi
		fi
	done < "sha256sum"

	echo "All checksums verified successfully."
}

baseDir=$( dirname "$( readlink -f $0 )" )
srcRootDir=$( dirname $baseDir )
rootDir=$( dirname $srcRootDir )
packagesDir="$rootDir/packages"

packageListFilePath="$srcRootDir/packages.txt"
[ -f $packageListFilePath ] || bail "Cannot find the package list file, $packageListFilePath."

localRepoPath="/usr/share/repos/local-repo"
[ -d $localRepoPath ] || mkdir -p $localRepoPath

echo "Verifying packages before copying..."
pushd $packagesDir
verifyChecksums
popd

echo "Copying packages to $localRepoPath..."
cp $packagesDir/* $localRepoPath -Rf

echo "Verifying packages after copying..."
pushd $localRepoPath
verifyChecksums
popd

keyringsPath="/etc/apt/keyrings"
[ -d $keyringsPath ] || install -d -m 0755 /etc/apt/keyrings

sourceKeyringsPath="$rootDir/keyrings"
if [ -d $sourceKeyringsPath ]; then
	echo "Copying keyrings..."
	cp $sourceKeyringsPath/* $keyringsPath -Rf
fi

sourceListPath="/etc/apt/sources.list.d"
[ -d $sourceListPath ] || mkdir -p $sourceListPath

additionalSourcesPath="$rootDir/sources.list.d"
if [ -d $additionalSourcesPath ]; then
	echo "Copying additional repo sources..."
	cp $additionalSourcesPath/* $sourceListPath -Rf
fi

preferencesPath="/etc/apt/preferences.d"

additionalPreferencesPath="$rootDir/preferences.d"
if [ -d $additionalPreferencesPath ]; then
	echo "Copying preferences..."
	cp $additionalPreferencesPath $preferencesPath -Rf
fi

echo "Generating repo meta data..."
echo "deb [trusted=yes] file:$localRepoPath ./" > /etc/apt/sources.list.d/offline.list

apt-get update
apt-get -y upgrade

packageList="$( grep ".*" $packageListFilePath|tr '\n' ' ' )"
apt-get -y install $packageList

# Install SDR++
dpkg --install $localRepoPath/sdrpp_ubuntu_noble_amd64.deb
apt-get --fix-broken -y install

qdbus org.kde.Shutdown /Shutdown logoutAndReboot
