#!/bin/sh

# from $Id: pkg-update-upgrade-auto.sh,v 1.3 2017/10/23 22:05:00 andreas Exp $
# use pkg and portupgrade
# rewritten for 10.3+, invoke remotely with logging into /var/log/
# requires: /usr/local/etc/sudoers.d/pkg-update-upgrade-auto 
#     $USERNAME ALL=(root) NOPASSWD : /root/bin/pkg-update-upgrade-auto.sh
# use 'visudo -f/usr/local/etc/sudoers.d/pkg-update-upgrade-auto' 
#     and 'chmod 440 /usr/local/etc/sudoers.d/pkg-update-upgrade-auto'


# call portsnap to update /usr/ports/
/usr/sbin/portsnap --interactive fetch 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1
#only one time 
#/usr/sbin/portsnap extract 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1
#after that update only
/usr/sbin/portsnap --interactive update 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1

/usr/bin/logger portsnap completed

# update
echo "pkg update" | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
/usr/local/sbin/pkg update 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
# check versions
/usr/local/sbin/pkg version |grep -v = 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
# upgrade
echo "pkg upgrade" | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
/usr/local/sbin/pkg upgrade -y 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
#clean, unconditionally
/usr/local/sbin/pkg clean -y 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1
#autoremove, it will ask for confirmation
#/usr/local/sbin/pkg autoremove 2>&1 | /usr/bin/tee -a /var/log/pkg-update-upgrade.log 2>&1

# check again for versions not equal, then run portupgrade
#/usr/local/sbin/pkg version |grep -v = 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1
#BATCH=YES /usr/local/sbin/portupgrade -arv 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1
#/usr/local/sbin/portsclean -CD 2>&1 | /usr/bin/tee -a /var/log/portupgrade-arv.log 2>&1

# do not ask for reboot, but give 30 seconds delay for interactice way to cancel
echo -n "System will reboot in 30 seconds, use CTRL-C to cancel "
for c in 10 20 30; do
  for s in 0 1 2 3 4 5 6 7 8 9; do
    echo -n "."
    sleep 1
    done
  echo -n $c
  done
echo
/usr/bin/logger $0 complete and rebooting now
exec /sbin/reboot;

exit 0
###EOF script
