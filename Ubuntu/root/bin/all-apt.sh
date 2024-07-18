#!/bin/sh

#check /var/run/needrestart/ for processes that need restarting
#Ubuntu 20.04 and 22.04 will indicate need for system reboot
set -ev
#set -x

/usr/bin/apt-get update
/usr/bin/apt list --upgradable
/usr/bin/apt-get -y dist-upgrade
/usr/bin/apt-get -y autoremove
/usr/bin/apt-get -y autoclean
/usr/bin/tac /var/log/apt/history.log | /usr/bin/awk '!flag; /Start-Date: /{flag = 1};' | /usr/bin/tac

/usr/bin/grep VERSION= /etc/os-release 

set +e
if [ -f /var/run/needrestart/* ]
then    
  /usr/bin/grep -nH . /var/run/needrestart/*
  /usr/bin/ls -lart /var/run/needrestart/
else    
  /usr/bin/ls -lart /var/run/needrestart/
fi

if [ -f /var/run/reboot-required ]
then
  /usr/bin/ls -lart /var/run/reboot-required*
  /usr/bin/grep -nH . /var/run/reboot-required*
fi
