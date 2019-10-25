#!/bin/sh

# $Id: freebsd-update.sh,v 1.6 2019/10/25 17:00:35 andreas Exp $
# new freebsd-update.sh for 10.2+, using onboard binary updates
# logging to /var/log/ and syslog

IFS=' '
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

### SET/CHANGE VARIABLES HERE
MY_UNAME=`/usr/bin/uname -a`
### END OF VARIABLES

# invoke self-destruction and explode if something goes wrong
set -e

echo "######## $0 ########" | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/bin/date | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/bin/freebsd-version -ku | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
echo ${MY_UNAME} | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/usr/sbin/freebsd-update fetch | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
#are updates needed?
/usr/bin/tail -1 /var/log/freebsd-update.log | /usr/bin/grep "No updates needed to update system"
#no
if [ X$? = "X0" ] ; then
        echo done ;
        /usr/bin/logger $0 determined that no updates are needed
        exit 0 ;                # exit right here, and skip reboot
fi
#yes
/usr/sbin/freebsd-update install | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1

#update motd
NEWVERSION=`/bin/freebsd-version -u`
/bin/cat /etc/motd| sed -e "s/^System:.*$/System: ${NEWVERSION}/g" >/etc/motd.new
/bin/mv /etc/motd.new /etc/motd
/bin/echo "/etc/motd has been updated to ${NEWVERSION}"

# now ask for reboot
echo -n "Do you want to reboot now? [NO|yes] "
read reply
if [ Y$reply = "Yyes" ] ; then
        /usr/bin/logger $0 complete and rebooting now
        exec /sbin/reboot;
        else
                /bin/echo "I hope you know what you are doing. No reboot."
                /usr/bin/logger $0 completed but no reboot
fi

exit 0;
###EOF script
