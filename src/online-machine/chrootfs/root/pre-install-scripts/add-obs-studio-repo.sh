#!/bin/bash

# Largely based off of OBS Studio's page:
# https://obsproject.com/download
add-apt-repository -y ppa:obsproject/obs-studio

apt-get install -y apt-transport-https

apt-get update
apt-get -y upgrade
