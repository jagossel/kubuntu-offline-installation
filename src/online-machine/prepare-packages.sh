#!/bin/bash

bail() {
	echo >&2 "$@"
	exit 1
}

baseDir=$( dirname "$( readlink -f $0 )" )
srcRootDir=$( dirname $baseDir )
rootDir=$( dirname $srcRootDir )

logPath="$baseDir/prepare-packages.log"
[ -f $logPath ] && rm $logPath

chrootDir="$rootDir/chroot"
if [ ! -d $chrootDir ]; then
	mkdir $chrootDir

	echo "Creating initial chroot environment..."
	debootstrap --arch=amd64 noble $chrootDir http://archive.ubuntu.com/ubuntu/ >> $logPath
fi

packageListFilePath="$srcRootDir/packages-core.txt"
[ -f $packageListFilePath ] || bail "Cannot find the package list file, $packageListFilePath."

getPackagesSourcePath="$baseDir/get-packages.sh"
[ -f $getPackagesSourcePath ] || bail "Cannot find the get package script, $getPackagesSourcePath."

cp $getPackagesSourcePath $chrootDir/root -f
cp $packageListFilePath $chrootDir/root -f

echo "Mounting temporary bindings for chroot..."
mount --bind /dev $chrootDir/dev
mount --bind /dev/pts $chrootDir/dev/pts
mount -t proc /proc $chrootDir/proc
mount -t sysfs /sys $chrootDir/sys
mount --bind /run $chrootDir/run
mount --bind /tmp $chrootDir/tmp

echo "Invoking get packages script in chroot..."
chroot $chrootDir bash /root/get-packages.sh >> $logPath

echo "Completed!  Unmounting temporary bindings..."
umount -R $chrootDir/{tmp,run,sys,proc,dev}

packagesDir="$rootDir/packages"
[ -d $packagesDir ] && rm $packagesDir -Rfv >> $logPath

mkdir $packagesDir

downloadedPackagesPath="$chrootDir/var/cache/apt/archives"
[ -d $downloadedPackagesPath ] || bail "It appears that debootstrap failed, cannot find the path, $downloadedPackagesPath."

echo "Copying packages from chroot environment..."
cp $downloadedPackagesPath/* $packagesDir -Rfv >> $logPath

echo "Removing chroot environment..."
rm $chrootDir -Rfv >> $logPath
