# Kubuntu 24.04 LTS Offline Installation

This is a series of scripts to use to:

 1. Prepare the media for offline installation while still connected to the internet.
 2. Perform an offline installation without the need of an Internet connection.

## Requirements

These scripts are to be executed on a base instance of Kubuntu 24.04 LTS.

In order to use these scripts, the following packages must be installed:
```debootstrap``` and ```dpkg-dev```.

There must be, at least, 40GB of space avaialble before executing these scripts.  It
will create an empty, chrooted, Ubuntu environment to download and install packages.
This is done so that a complete acrhive of the packages will be available for
offline installation.

Once the process is done, the chroot environment will be removed, but the pacakges
will remain.

## Online Machine: Package Preparation

To prepare the packages for offline installation, go to the folder,
```src/online-machine```, and execute the script, ```prepare-packages.sh```:

```bash
cd src/online-machine
sudo bash prepare-packages.sh
```

This will take a significant amount of time to complete as it creates a base,
chrooted environment, install the packages, copies the pacakges, and then generates
the minimum required repostory files for ```apt-get```.

Once the process has been completed, store the entire folder from this repository
onto a storage medium of choice.

## Offline Machine: Installation

After the base installation of Kubuntu 24.04 LTS is complete, mount the storage
medium, and execute the ```src/offline-machine/install-packages.sh``` script:

```bash
cd src/offline-machine
sudo bash install-packages.sh
```
