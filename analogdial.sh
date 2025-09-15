#!/bin/bash

# source variables file
source ./variables.sh

# Update and aquire packages first
apt-get update
apt-get install -y sudo ppp mgetty htop neofetch

# Give my user the sudo group
usermod -aG sudo nuso

# Configure and start mgetty
printf "%s\n" "$mgetty" >> /lib/systemd/system/mgetty@.service
rm /etc/mgetty/mgetty.config
printf "%s\n" "$modem" >> /etc/mgetty/mgetty.config
systemctl enable --now mgetty@ttyACM0.service
systemctl enable --now mgetty@ttyds01.service

# Setup and configure ppp
rm /etc/ppp/options
printf "%s\n" "$ppp" >> /etc/ppp/options
printf "%s\n" "$pppoptions" >> /etc/ppp/options.ttyACM0

# Setup the users for dialing in
useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd nuso
printf "nuso:112406" | chpasswd
printf "nuso * "112406" *" >> /etc/ppp/pap-secrets
useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd nova
printf "nova:112406" | chpasswd
printf "nova * "112406" *" >> /etc/ppp/pap-secrets

# Configure ip forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
ufw disable
ufw allow ssh
ufw allow 1222/tcp
ufw allow 10005
printf "%s\n" "$ufw" >> /etc/ufw/before.rules
printf "y" | ufw enable 

