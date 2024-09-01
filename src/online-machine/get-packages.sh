# Configure the locale; this will be required when installing the packages.
echo "en_US.UTF-8 UTF-8">/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8 UTF-8">/etc/locale.conf

# Properly set up the repository sources so we can get the packages needed.
rm /etc/apt/sources.list

echo "deb http://archive.ubuntu.com/ubuntu noble main universe restricted multiverse" | tee -a /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ noble-security main universe restricted multiverse" | tee -a /etc/apt/sources.list

apt-get update
apt-get -y upgrade

# Concatenate the package list into a single line, this should reduce the logging some.
packageList="$( grep ".*" /root/packages-core.txt|tr '\n' ' ' )"
apt-get -y install $packageList
