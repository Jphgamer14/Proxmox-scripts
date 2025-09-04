#!/bin/bash
mgetty="[Unit]
Description=External Modem %I
Documentation=man:mgetty(8)
Requires=systemd-udev-settle.service
After=systemd-udev-settle.service

[Service]
Type=simple
ExecStart=/sbin/mgetty /dev/%i
Restart=always
PIDFile=/var/run/mgetty.pid.%i

[Install]
WantedBy=multi-user.target"

rclocal="[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

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
 rings 2"