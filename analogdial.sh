#!/bin/bash
#Update and aquire packages first
apt-get update
apt-get install -y sudo ppp mgetty

#Give my user the sudo group
usermod -aG sudo nuso


