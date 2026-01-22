#!/bin/bash
# this is the data disk for the Proxmox PBS on this Proxmox PVE
# invoke from root crontab like "12 11 * * *	/root/bin/zfs-snapshot.sh"
NOW=`/usr/bin/date +%Y%m%dZ%H%M%S`

/usr/sbin/zfs snapshot sda-zfs/vm-243-disk-0@${NOW} 

# zfs list
# zfs list -t snapshot
# zfs destroy -p -r sda-zfs/vm-243-disk-0@20260122Z111213
