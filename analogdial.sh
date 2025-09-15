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

# Configure ip forwarding and iptables
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
echo "1" | update-alternatives --config iptables
sed -i '/^exit 0$/ iptables -t nat -A POSTROUTING -s 192.168.32.0/24 -o ens18 -j MASQUERADE' /etc/rc.local

