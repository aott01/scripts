#!/bin/sh

# takes downloaded cloudimage and creates VM with some cloudinit variables set, 
#	then turns into	a template; 
#	code after 'exit 0' deploys VM from template, set disk size, mem, cores etc.

qm destroy 9000
qm create 9000 --name "ub24043-cloudinit-template" --memory 2048 --cores 1 --net0 virtio,bridge=vmbr33
qm importdisk 9000 /var/lib/vz/template/qemu/noble-server-cloudimg-amd64.img sdb-lvm
qm set 9000 --scsihw virtio-scsi-pci --scsi0 sdb-lvm:vm-9000-disk-0,discard=on,iothread=1,ssd=1
qm set 9000 --boot c --bootdisk scsi0
qm set 9000 --ide2 sdb-lvm:cloudinit
qm set 9000 --ipconfig0 ip=dhcp
qm set 9000 --ciuser ansible --cipassword '1-Ansible'
qm template 9000

exit 0

qm destroy 9113
qm clone 9000 9113 --name "new-ubuntu-vm"
qm set 9113 --agent 1 --autostart 0 --bios seabios --cores 2 --cpu x86-64-v2-AES --memory 4096
qm disk resize 9113 scsi0 8G



