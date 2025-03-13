!#/bin/sh

# see https://ata.wiki.kernel.org/index.php/ATA_Secure_Erase
# and saved naund email from 2021-02-05
echo this does unspeakable things to your data, therefore invoke all of it manually

echo << EOF
# intelmas SSD toolkit
# smartctl
# hdparm

#firmware
intelmas show -intelssd
intelmas load -intelssd 1
#self test
smartctl -a /dev/sdZ
smartctl -t long /dev/sdZ
smartctl -a /dev/sdZ|less
#secure erase
hdparm -I /dev/sdZ
hdparm --user-master u --security-set-pass Eins /dev/sdZ
time hdparm --user-master u --security-erase Eins /dev/sdZ
hdparm -I /dev/sdZ

EOF
