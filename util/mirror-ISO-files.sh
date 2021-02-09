#/bin/sh

# adopted from... $Id: get-ISO-files.sh,v 1.18 2021/02/02 20:39:35 andreas Exp $
# prepoluate mirror ISOs
# NOTES: 
#       onboard wget busybox call binary does not do https://
#       no bunzip2 (on ESXi 6.5) or unxz to uncompress images

#cd /vmfs/volumes/datastore1/
#mkdir -p ISOs
#cd ISOs

mkdir -p ./CentOS
cd CentOS 
wget -c http://mirrors.edge.kernel.org/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
#
wget -c http://mirrors.edge.kernel.org/centos/8.3.2011/isos/x86_64/CentOS-8.3.2011-x86_64-dvd1.iso
cd ..

mkdir -p ./FreeBSD
cd FreeBSD
wget -c http://ftp4.us.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/11.4/FreeBSD-11.4-RELEASE-amd64-dvd1.iso
#
wget -c http://ftp4.us.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/12.2/FreeBSD-12.2-RELEASE-amd64-dvd1.iso
cd ..

mkdir -p ./TrueNAS
cd TrueNAS
#wget -c http://download.freenas.org/12.0/STABLE/RELEASE/x64/TrueNAS-12.0-RELEASE.iso
wget -c http://download.freenas.org/12.0/STABLE/U1.1/x64/TrueNAS-12.0-U1.1.iso
cd ..

mkdir -p ./Kali
cd Kali
wget -c http://cdimage.kali.org/kali-2020.3/kali-linux-2020.3-installer-amd64.iso
wget -c http://cdimage.kali.org/kali-2020.3/kali-linux-2020.3-live-amd64.iso
cd ..

mkdir -p ./Ubuntu
cd Ubuntu
#wget -c http://mirrors.kernel.org/ubuntu-releases/16.04.4/ubuntu-16.04.4-server-amd64.iso
#wget -c http://mirrors.kernel.org/ubuntu-releases/18.04.5/ubuntu-18.04.4-live-server-amd64.iso
wget -c http://cdimage.ubuntu.com/releases/18.04.5/release/ubuntu-18.04.5-server-amd64.iso
wget -c http://mirrors.kernel.org/ubuntu-releases/20.04.1/ubuntu-20.04.1-live-server-amd64.iso
cd ..

mkdir -p ./pfSense
cd pfSense
#wget -c http://atxfiles.pfsense.org/mirror/downloads/pfSense-CE-2.4.5-RELEASE-p1-amd64.iso.gz
#gunzip pfSense-CE-2.4.5-RELEASE-p1-amd64.iso.gz
cd ..

mkdir -p OPNsense
cd OPNsense
#wget -vc http://mirror.sfo12.us.leaseweb.net/opnsense/releases/mirror/OPNsense-20.7-OpenSSL-dvd-amd64.iso.bz2
#bunzip2 OPNsense-20.7-OpenSSL-dvd-amd64.iso.bz2
cd ..

find . -ls

###EOF script
