#!/bin/bash

# source variables file
source ./variables.sh

# Update and aquire packages first
apt-get update
apt-get install -y ppp mgetty htop screenfetch wget build-essential linux-headers-$(uname -r)

# grab and run the diva software required for ISDN Card
curl --user "nuso:112406" -O ftp://192.168.1.9/nas/drivers/Diva.bin
chmod +x Diva.bin
./Diva.bin
cd /usr/lib/opendiva/divas/src
./Build -auto-locate-kernel-sources
sed -i "1s/.*/11242006/" "/usr/lib/opendiva/divas/httpd/login/login.README"
mv /usr/lib/opendiva/divas/httpd/login/login.README /usr/lib/opendiva/divas/httpd/login/login


# Configure and start mgetty
printf "%s\n" "$mgetty" >> /lib/systemd/system/mgetty@.service
rm /etc/mgetty/mgetty.config
printf "%s\n" "$modem" >> /etc/mgetty/mgetty.config
systemctl enable --now mgetty@ttyACM0.service
systemctl enable --now mgetty@ttyds01.service
systemctl enable --now mgetty@ttyds02.service

# Setup and configure ppp
rm /etc/ppp/options
printf "%s\n" "$ppp" >> /etc/ppp/options
printf "%s\n" "$pppoptions" >> /etc/ppp/options.ttyACM0

# Setup the users for dialing in
useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd lazual
printf "lazual:112406" | chpasswd
printf "lazual * "112406" *" >> /etc/ppp/pap-secrets

useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd nova
printf "nova:112406" | chpasswd
printf "nova * "112406" *" >> /etc/ppp/pap-secrets

useradd -G dialout,dip,users -m -g users -s /usr/sbin/pppd bryson
printf "bryson:112406" | chpasswd
printf "bryson * "112406" *" >> /etc/ppp/pap-secrets

# Configure ip forwarding
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p /etc/sysctl.conf
echo "net/ipv4/ip_forward=1" >> /etc/ufw/sysctl.conf
sed -i 's/^DEFAULT_FORWARD_POLICY="DROP"/DEFAULT_FORWARD_POLICY="ACCEPT"/' "/etc/default/ufw"
ufw disable
ufw allow ssh
ufw allow 1222/tcp
ufw allow 10005
printf "%s\n" "$ufw" >> /etc/ufw/before.rules
printf "y" | ufw enable 

