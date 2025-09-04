#!/bin/bash

# source variables file
source ./variables.sh

# Update and aquire packages first
apt-get update
apt-get install -y sudo ppp mgetty

# Give my user the sudo group
usermod -aG sudo nuso

# Configure mgetty
echo $mgetty >> /lib/systemd/system/mgetty@.service
rm /etc/mgetty/mgetty.config
echo 

