#!/bin/sh
# macOS Monterey 12.x on MBP 13-in 2018

# check for external drive, else exit
mount |grep "/dev/disk2s1 on /Volumes/SabrentUSB"
if [[ $? > 0 ]] ; then
        echo external USB not mounted, please check
        exit 1
fi

set -e

echo backing up to external SabrentUSB
echo currently commented out options: '--delete ' '-z --bwlimit=128' '--exclude="*.vdi" --exclude="*/com.adobe.flashplayer.installmanager*" ' '--exclude="Downloads/*" '

echo capturing ls-lR-Downloads and du-hs-HOME
ls -lR ~/Downloads > ~/Documents/priv/ls-lR-Downloads
cd ~
du -hs ./.* ./* > ~/Documents/priv/du-hs-HOME
rsync $1 $2 $3 $4 $5 --exclude=".Trash" --exclude="Library/*" --progress -vvra . /Volumes/SabrentUSB/mbp22/

sleep 10
sync

echo ejecting external USB drive now
diskutil list /dev/disk2
diskutil unmountDisk /dev/disk2
diskutil eject /dev/disk2
echo ejected USB external drive
mount
diskutil list

exit 0
