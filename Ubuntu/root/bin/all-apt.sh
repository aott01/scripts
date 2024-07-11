#!/bin/sh

set -ev

/usr/bin/apt-get update
/usr/bin/apt list --upgradable
/usr/bin/apt-get -y dist-upgrade
/usr/bin/apt-get -y autoremove
/usr/bin/apt-get -y autoclean
/usr/bin/tac /var/log/apt/history.log | /usr/bin/awk '!flag; /Start-Date: /{flag = 1};' | /usr/bin/tac

/usr/bin/grep VERSION= /etc/os-release 
/usr/bin/ls -lart /var/run/needrestart/
