#!/bin/sh

PATH=/usr/bin

grep startup /etc/pve/qemu-server/* /etc/pve/lxc/* | awk -F'order=' '{print $2, $0}' | sort -n | cut -d' ' -f2-
