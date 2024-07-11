#!/bin/sh

#Ubuntu 22.04 uses /var/run/needrestart/
#TODO: ?Ubunttu 24.04?, Ubuntu 20.04 see below
set -ev

/usr/bin/apt-get update
/usr/bin/apt list --upgradable
/usr/bin/apt-get -y dist-upgrade
/usr/bin/apt-get -y autoremove
/usr/bin/apt-get -y autoclean
/usr/bin/tac /var/log/apt/history.log | /usr/bin/awk '!flag; /Start-Date: /{flag = 1};' | /usr/bin/tac

/usr/bin/grep VERSION= /etc/os-release 
/usr/bin/ls -lart /var/run/needrestart/
# show content of file(s)

#for Ubuntu 20.04 LTS
# /usr/bin/ls -lart /var/run/reboot-required*
# /usr/bin/grep -nH . /var/run/reboot-required*
