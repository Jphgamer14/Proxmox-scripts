#!/bin/bash
mgetty="[Unit]
Description=External Modem %I
Documentation=man:mgetty(8)
Requires=systemd-udev-settle.service divastart.service
After=systemd-udev-settle.service divastart.service

[Service]
Type=simple
ExecStart=/sbin/mgetty /dev/%i
Restart=always
PIDFile=/var/run/mgetty.pid.%i

[Install]
WantedBy=multi-user.target"

 modem="debug 9

port ttyACM0
 port-owner root
 port-group dialout
 port-mode 0660
 data-only yes
 ignore-carrier no
 toggle-dtr yes
 toggle-dtr-waittime 500
 rings 2
 
port ttyds01
 port-owner root
 port-group dialout
 port-mode 0660
 init-chat \"\" AT&F14+IF5+IM4;S0=0
 data-only yes
 ignore-carrier no
 toggle-dtr no
 toggle-dtr-waittime 500
 rings 2

port ttyds02
 port-owner root
 port-group dialout
 port-mode 0660
 init-chat \"\" AT&F14+IF5+IM4;S0=0
 data-only yes
 ignore-carrier no
 toggle-dtr no
 toggle-dtr-waittime 500
 rings 2"

 ppp="# Define the DNS server for the client to use
ms-dns 8.8.8.8
# async character map should be 0
asyncmap 0
# Require authentication
auth
# Use hardware flow control
crtscts
# We want exclusive access to the modem device
lock
# Show pap passwords in log files to help with debugging
show-password
# Require the client to authenticate with pap
+pap
# If you are having trouble with auth enable debugging
debug
# Heartbeat for control messages, used to determine if the client connection has dropped
lcp-echo-interval 30
lcp-echo-failure 4
# Cache the client mac address in the arp system table
proxyarp
# Disable the IPXCP and IPX protocols.
noipx"

pppACM="local
lock
nocrtscts
192.168.2.1:192.168.2.2
netmask 255.255.255.0
noauth
proxyarp
lcp-echo-failure 60
multilink
bundle mybundle
mrru 1524
mtu 1500
mru 1500
nobsdcomp"

pppDS1="local
lock
nocrtscts
192.168.2.3:192.168.2.4
netmask 255.255.255.0
noauth
proxyarp
lcp-echo-failure 60
multilink
bundle mybundle
mrru 1524
mtu 1500
mru 1500
nobsdcomp"

pppDS2="local
lock
nocrtscts
192.168.2.5:192.168.2.6
netmask 255.255.255.0
noauth
proxyarp
lcp-echo-failure 60
multilink
bundle mybundle
mrru 1524
mtu 1500
mru 1500
nobsdcomp"

ufw="*nat
:PREROUTING ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
-A POSTROUTING -s 192.168.1.0/24 -o ens18 -j MASQUERADE
COMMIT"

divastart="[Unit]
Description=Diva System Release Startup Script
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/lib/opendiva/divas/Start
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target"