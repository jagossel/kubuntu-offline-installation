#!/bin/bash

# Largely based off of https://docs.docker.com/engine/install/ubuntu/
apt-get update
apt-get install -y ca-certificates curl

[ -d "/etc/apt/keyrings" ] || install -m 0755 -d /etc/apt/keyrings
[ -f "/etc/apt/keyrings/docker.asc" ] || curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

[ -d "/etc/apt/sources.list.d" ] || mkdir -p /etc/apt/sources.list.d
[ -f "/etc/apt/sources.list.d/docker.list" ] || echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
