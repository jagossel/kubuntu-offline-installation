#!/bin/bash

# Largely based off of Microsoft's page:
# https://code.visualstudio.com/docs/setup/linux
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /tmp/packages.microsoft.gpg

if [ ! -f '/etc/apt/keyrings/packages.microsoft.gpg' ]; then
	install -D -o root -g root -m 644 /tmp/packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
fi

if [ ! -f '/etc/apt/sources.list.d/vscode.list' ]; then
	echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | tee /etc/apt/sources.list.d/vscode.list > /dev/null
fi

rm -f /tmp/packages.microsoft.gpg
