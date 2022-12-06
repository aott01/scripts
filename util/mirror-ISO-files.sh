#/bin/sh

# adopted from... $Id: get-ISO-files.sh,v 1.18 2021/02/02 20:39:35 andreas Exp $
# prepoluate mirror ISOs on ESXi host
# NOTES: 
#       onboard wget busybox call binary does not do https://
#       no bunzip2 (on ESXi 6.5) or unxz to uncompress images

#cd /vmfs/volumes/datastore1/
#mkdir -p ISOs
#cd ISOs

#mkdir -p ./CentOS
#cd CentOS 
#wget -c http://mirrors.edge.kernel.org/centos/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
#
#wget -c http://mirrors.edge.kernel.org/centos/8.3.2011/isos/x86_64/CentOS-8.3.2011-x86_64-dvd1.iso
#cd ..

mkdir -p ./almalinux
cd almalinux
wget -c http://la.mirrors.clouvider.net/almalinux/8.7/isos/x86_64/AlmaLinux-8.7-x86_64-dvd.iso
wget -c http://la.mirrors.clouvider.net/almalinux/9.1/isos/x86_64/AlmaLinux-9.1-x86_64-dvd.iso
cd ..

mkdir -p ./FreeBSD
cd FreeBSD
#
#wget -c http://ftp4.us.freebsd.org/pub/FreeBSD/releases/ISO-IMAGES/11.4/FreeBSD-11.4-RELEASE-amd64-dvd1.iso
#
#wget -c https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/12.3/FreeBSD-12.3-RELEASE-amd64-dvd1.iso
wget -c https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/12.4/FreeBSD-12.4-RELEASE-amd64-dvd1.iso
#
wget -c https://download.freebsd.org/releases/amd64/amd64/ISO-IMAGES/13.1/FreeBSD-13.1-RELEASE-amd64-dvd1.iso
cd ..

mkdir -p ./TrueNAS core
cd TrueNAS
#wget -c http://download.freenas.org/12.0/STABLE/RELEASE/x64/TrueNAS-12.0-RELEASE.iso
wget -c http://download.freenas.org/12.0/STABLE/U8.1/x64/TrueNAS-12.0-U8.1.iso
wget -c http://download.freenas.org/13.0/STABLE/U3.1/x64/TrueNAS-13.0-U3.1.iso
cd ..

mkdir -p ./Kali
cd Kali
wget -c http://cdimage.kali.org/kali-2022.3/kali-linux-2022.3-installer-amd64.iso
wget -c http://cdimage.kali.org/kali-2022.3/kali-linux-2022.3-live-amd64.iso
cd ..

mkdir -p ./Ubuntu
cd Ubuntu
#wget -c http://mirrors.kernel.org/ubuntu-releases/16.04.4/ubuntu-16.04.4-server-amd64.iso
#wget -c http://mirrors.kernel.org/ubuntu-releases/18.04.5/ubuntu-18.04.4-live-server-amd64.iso
wget -c http://cdimage.ubuntu.com/releases/18.04.5/release/ubuntu-18.04.5-server-amd64.iso
wget -c http://mirrors.edge.kernel.org/ubuntu-releases/20.04.5/ubuntu-20.04.5-live-server-amd64.iso
wget -c http://mirrors.edge.kernel.org/ubuntu-releases/22.04.1/ubuntu-22.04.1-live-server-amd64.iso
cd ..

mkdir -p ./pfSense
cd pfSense
#wget -c http://atxfiles.pfsense.org/mirror/downloads/pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
#gunzip pfSense-CE-2.6.0-RELEASE-amd64.iso.gz
cd ..

mkdir -p OPNsense
cd OPNsense
#wget -vc http://mirror.sfo12.us.leaseweb.net/opnsense/releases/22.7/OPNsense-22.7-OpenSSL-dvd-amd64.iso.bz2
#bunzip2 OPNsense-22.7-OpenSSL-dvd-amd64.iso.bz2
cd ..

find . -ls

###EOF script
