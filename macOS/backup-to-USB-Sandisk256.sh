#!/bin/sh
# macOS Monterey 12.x on MBP 13-in 2018

# check for external drive, else exit
mount |grep "/dev/disk2s1 on /Volumes/SANDISK256"
if [[ $? > 0 ]] ; then
	echo USB stick not mounted, please check
	exit 1
fi

set -e

echo backing up to USB SanDisk256
echo currently commented out options: '--delete ' '-z --bwlimit=128' '--exclude="*.vdi" --exclude="*/com.adobe.flashplayer.installmanager*" ' '--exclude="Downloads/*" '

echo capturing ls-lR-Downloads and du-hs-HOME
ls -lR ~/Downloads > ~/Documents/priv/ls-lR-Downloads
cd ~
du -hs ./.* ./* > ~/Documents/priv/du-hs-HOME
rsync $1 $2 $3 $4 $5 --exclude=".Trash" --exclude="Library/*" --exclude=Downloads/Microsoft/Windows11.iso --exclude=Downloads/PaloAlto/PA-VM-KVM-10.1.12.qcow2 --exclude="work-HorizonIQ/_uploaded/*" --exclude="Downloads/*ubuntu*.iso" --progress -vra . /Volumes/SanDisk256/mbp22/

sleep 13
sync

echo ejecting external USB drive now
diskutil list /dev/disk2
sync
diskutil unmountDisk /dev/disk2
diskutil eject /dev/disk2
echo ejected USB external drive
mount
diskutil list

exit 0
