# Configure the locale; this will be required when installing the packages.
echo "en_US.UTF-8 UTF-8">/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8 UTF-8">/etc/locale.conf

# Properly set up the repository sources so we can get the packages needed.
rm /etc/apt/sources.list

echo "deb http://archive.ubuntu.com/ubuntu noble main universe restricted multiverse" | tee -a /etc/apt/sources.list
echo "deb http://security.ubuntu.com/ubuntu/ noble-security main universe restricted multiverse" | tee -a /etc/apt/sources.list

apt-get update
apt-get install -y gpg wget

# Largely based off of Mozilla's page:
# https://support.mozilla.org/en-US/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-distributions-recommended
if [ ! -d '/etc/apt/keyrings' ]; then
	install -d -m 0755 /etc/apt/keyrings
fi

if [ ! -f '/etc/apt/keyrings/packages.mozilla.org.asc' ]; then
	wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
	gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'
fi

if [ ! -f '/etc/apt/sources.list.d/mozilla.list' ]; then
	echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
fi

if [ ! -f '/etc/apt/preferences.d/mozilla' ]; then
	echo '
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
' | tee /etc/apt/preferences.d/mozilla
fi

apt-get update
apt-get -y upgrade

# Concatenate the package list into a single line, this should reduce the logging some.
packageList="$( grep ".*" /root/packages-core.txt|tr '\n' ' ' )"
apt-get -y install kubuntu-desktop $packageList
