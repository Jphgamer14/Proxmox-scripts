#!/bin/bash
mgetty="[Unit]\n
Description=External Modem %I\n
Documentation=man:mgetty(8)\n
Requires=systemd-udev-settle.service\n
After=systemd-udev-settle.service\n
\n
[Service]\n
Type=simple\n
ExecStart=/sbin/mgetty /dev/%i\n
Restart=always\n
PIDFile=/var/run/mgetty.pid.%i\n
\n
[Install]\n
WantedBy=multi-user.target"

rclocal="[Unit]\n
 Description=/etc/rc.local Compatibility\n
 ConditionPathExists=/etc/rc.local\n
\n
[Service]\n
 Type=forking\n
 ExecStart=/etc/rc.local start\n
 TimeoutSec=0\n
 StandardOutput=tty\n
 RemainAfterExit=yes\n
 SysVStartPriority=99\n
\n
[Install]\n
 WantedBy=multi-user.target"

 modem="debug 9\n
\n
port ttyACM0\n
 port-owner root\n
 port-group dialout\n
 port-mode 0660\n
 data-only yes\n
 ignore-carrier no\n
 toggle-dtr yes\n
 toggle-dtr-waittime 500\n
 rings 2"

 ppp="# Define the DNS server for the client to use\n
ms-dns 8.8.8.8\n
# async character map should be 0\n
asyncmap 0\n
# Require authentication\n
auth\n
# Use hardware flow control\n
crtscts\n
# We want exclusive access to the modem device\n
lock\n
# Show pap passwords in log files to help with debugging\n
show-password\n
# Require the client to authenticate with pap\n
+pap\n
# If you are having trouble with auth enable debugging\n
debug\n
# Heartbeat for control messages, used to determine if the client connection has dropped\n
lcp-echo-interval 30\n
lcp-echo-failure 4\n
# Cache the client mac address in the arp system table\n
proxyarp\n
# Disable the IPXCP and IPX protocols.\n
noipx"

pppoptions="local\n
lock\n
nocrtscts\n
192.168.1.200:192.168.1.201\n
netmask 255.255.255.0\n
noauth\n
proxyarp\n
lcp-echo-failure 60"