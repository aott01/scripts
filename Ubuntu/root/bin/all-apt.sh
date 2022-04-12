#!/bin/sh

set -e

/usr/bin/apt-get update
/usr/bin/apt-get -y dist-upgrade
/usr/bin/apt-get -y autoremove
/usr/bin/apt-get -y autoclean
