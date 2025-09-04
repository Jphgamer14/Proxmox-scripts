#!/bin/bash

# source variables file
source ./variables.sh

# Update and aquire packages first
apt-get update
apt-get install -y sudo ppp mgetty iptables

# Give my user the sudo group
usermod -aG sudo nuso

# Configure and start mgetty
printf $mgetty >> /lib/systemd/system/mgetty@.service
rm /etc/mgetty/mgetty.config
printf $modem >> /etc/mgetty/mgetty.config
systemctl enable --now mgetty@ttyACM0.service

# Setup and configure ppp
rm /etc/ppp/options
printf $ppp >> /etc/ppp/options
printf $pppoptions >> /etc/ppp/options.ttyACM0

# Setup the user for dialing in
useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd dial
printf "dial:dial" | chpasswd
printf "dial * "dial" *" >> /etc/ppp/pap-secrets

# Setup rc-local file and service
printf '%s\n' '#!/bin/bash' 'exit 0' | sudo tee -a /etc/rc.local
chmod +x /etc/rc.local
printf $rclocal >> /etc/systemd/system/rc-local.service
systemctl enable rc-local

# Configure ip forwarding and iptables
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
echo "1" | update-alternatives --config iptables
sed -i '1a\iptables -t nat -A POSTROUTING -s 192.168.32.0/24 -o ens18 -j MASQUERADE

