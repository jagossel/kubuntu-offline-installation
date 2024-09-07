#!/bin/bash

keepChroot=NO
useExistingPackages=NO

# Parse any parameters that have been passed.
while [[ $# -gt 0 ]]; do
	case $1 in
		--keep-chroot)
			keepChroot=YES
			shift
			;;
		--use-existing-packages)
			useExistingPackages=YES
			shift
			;;
		--*)
			echo "Unknown argument: $1"
			exit 1
			;;
	esac
done

# Need a way to quickly exit out of the script.
bail() {
	echo >&2 "$@"
	exit 1
}

# Set up some pathing up-front.
baseDir=$( dirname "$( readlink -f $0 )" )
srcRootDir=$( dirname $baseDir )
rootDir=$( dirname $srcRootDir )
packagesDir="$rootDir/packages"

if [ $useExistingPackages != "YES" ]; then
	chrootDir="$rootDir/chroot"
	if [ ! -d $chrootDir ]; then
		mkdir $chrootDir

		echo "Creating initial chroot environment (this will take a few minutes)..."
		debootstrap --arch=amd64 noble $chrootDir http://archive.ubuntu.com/ubuntu/
	fi

	packageListFilePath="$srcRootDir/packages.txt"
	[ -f $packageListFilePath ] || bail "Cannot find the package list file, $packageListFilePath."

	getPackagesSourcePath="$baseDir/get-packages.sh"
	[ -f $getPackagesSourcePath ] || bail "Cannot find the get package script, $getPackagesSourcePath."

	# Copy scripts that can only be executed in the chroot environment.
	cp $getPackagesSourcePath $chrootDir/root -f
	cp $packageListFilePath $chrootDir/root -f

	# Prepare for the chrooted environment.
	echo "Mounting temporary bindings for chroot..."
	mount --bind /dev $chrootDir/dev
	mount --bind /dev/pts $chrootDir/dev/pts
	mount -t proc /proc $chrootDir/proc
	mount -t sysfs /sys $chrootDir/sys
	mount --bind /run $chrootDir/run
	mount --bind /tmp $chrootDir/tmp

	# Invoke the script in the chrooted environment.
	echo "Invoking get packages script in chroot (this will take a few minutes)..."
	chroot $chrootDir bash /root/get-packages.sh

	# Done with the chrooted environment, unmount to prevent issues with the system host.
	echo "Completed!  Unmounting temporary bindings..."
	umount -R $chrootDir/{tmp,run,sys,proc,dev}

	[ -d $packagesDir ] && rm $packagesDir -Rf
	mkdir $packagesDir

	# At this point, it should be safe to copy all of the packages over.
	downloadedPackagesPath="$chrootDir/var/cache/apt/archives"
	[ -d $downloadedPackagesPath ] || bail "It appears that debootstrap failed, cannot find the path, $downloadedPackagesPath."

	echo "Copying packages from chroot environment..."
	cp $downloadedPackagesPath/* $packagesDir -Rf

	# Copy the keyring
	sourceKeyringPath="$chrootDir/etc/apt/keyrings"
	if [ -d $sourceKeyringPath ]; then
		keyringPath="$rootDir/keyrings"
		[ -d $keyringPath ] && rm $keyringPath -Rf

		echo "Copying keyrings from chroot environment..."
		mkdir -p $rootDir/keyrings
		cp $sourceKeyringPath/* $keyringPath -Rf
	fi

	# Copy the repo source lists
	addedSourceListPath="$chrootDir/etc/apt/sources.list.d"
	if [ -d $addedSourceListPath ]; then
		sourceListPath="$rootDir/sources.list.d"
		[ -d $sourceListPath ] && rm $sourceListPath -Rf

		echo "Copying source lists from chroot environment..."
		mkdir -p $sourceListPath
		cp $addedSourceListPath/* $sourceListPath -Rf
	fi

	# Copy preferences files
	addedPreferencesPath="$chrootDir/etc/apt/preferences.d"
	if [ -d $addedPreferencesPath ]; then
		preferencesPath="$rootDir/preferences.d"
		[ -d $preferencesPath ] && rm $preferencesPath -Rf

		echo "Copy preferences from chroot environment..."
		mkdir -p $preferencesPath
		cp $addedPreferencesPath/* $preferencesPath -Rf
	fi

	if [ $keepChroot != "YES" ]; then
		echo "Removing chroot environment..."
		rm $chrootDir -Rf
	fi
fi

# Generate the package index gzip file.
packageIndexPath="$packagesDir/Packages"
echo "Generating the $packageIndexPath..."
dpkg-scanpackages $packagesDir > $packageIndexPath
sed -i "s|$packagesDir||g" $packageIndexPath

packageIndexCompressedPath="$packageIndexPath.gz"
gzip -9c $packageIndexPath > $packageIndexCompressedPath

rm $packageIndexPath

packagesMd5Hash="$( md5sum $packageIndexCompressedPath | awk '{print $1}' )"
packagesSha256Hash="$( sha256sum $packageIndexCompressedPath | awk '{print $1}' )"

# Generate the Release file.
releaseFilePath="$packagesDir/Release"
[ -f $releaseFilePath ] && rm $releaseFilePath -f

echo "Generating the $releaseFilePath..."
echo "Origin: Local Repository" > $releaseFilePath
echo "Label: Local Repository" >> $releaseFilePath
echo "Suite: unstable" >> $releaseFilePath
echo "Codename: noble" >> $releaseFilePath
echo "Architectures: amd64" >> $releaseFilePath
echo "Components: offline" >> $releaseFilePath
echo "Description: A local repository for offline installation of packages." >> $releaseFilePath
echo "MD5Sum:" >> $releaseFilePath
echo " $packagesMd5Hash" >> $releaseFilePath
echo "SHA256:" >> $releaseFilePath
echo " $packagesSha256Hash" >> $releaseFilePath
