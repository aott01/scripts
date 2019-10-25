#!/bin/sh

# $Id: pkg-update-upgrade.sh,v 1.2 2019/10/25 17:55:27 andreas Exp $
# use pkg (and portupgrade, uncomment if that is needed)
# rewritten for 10.2+
# logging to /var/log/ and syslog

# call portsnap to update
/root/bin/portsnap.sh

echo "######## $0 ########" | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
/bin/date | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
# update
echo "pkg update" | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
/usr/local/sbin/pkg update 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
# check versions
/usr/local/sbin/pkg version all |grep -v = 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
# upgrade
echo "pkg upgrade" | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
/usr/local/sbin/pkg upgrade 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
#clean, unconditionally
/usr/local/sbin/pkg clean -y 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
#autoremove, it will ask for confirmation
/usr/local/sbin/pkg autoremove 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1

# check again for versions not equal, then run portupgrade
#/usr/local/sbin/pkg version all |grep -v = 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1
#BATCH=YES /usr/local/sbin/portupgrade -arv 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1
#/usr/local/sbin/portsclean -CD 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1

/usr/bin/logger $0 completed
exit 0
###EOF script
