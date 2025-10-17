#!/bin/sh

# creates VM (will destroy existing one without asking!) with settings;
#	mounted ISO booting installer...

qm destroy 111
qm create 111 --name ub24043live \
--agent 1 --autostart 0 --bios seabios --cores 2 --cpu x86-64-v2-AES --memory 4096 --net0 virtio,bridge=vmbr33 \
--scsi0 sdb-lvm:16,discard=on,iothread=1,ssd=1 --scsihw virtio-scsi-single  --sockets 1 --tags ubuntu \
--ide2 local:iso/ubuntu-24.04.3-live-server-amd64.iso,media=cdrom,size=3137758K --boot order="ide2;scsi0"

echo Results: 
qm config 111
