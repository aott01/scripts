#!/bin/sh

# from $Id: freebsd-update-auto.sh,v 1.2 2017/10/23 22:05:00 andreas Exp $
# freebsd-update-auto.sh for 10.3+, using onboard binary updates
#       automated all-in-one
# logging to terminal (invoke remotely) and to /var/log/
# requires: /usr/local/etc/sudoers.d/freebsd-update-auto
#     $USERNAME ALL=(root) NOPASSWD : /root/bin/freebsd-update-auto.sh
# use 'visudo -f/usr/local/etc/sudoers.d/freebsd-update-auto'
#     and 'chmod 440 /usr/local/etc/sudoers.d/freebsd-update-auto'
# now handling motd.tetmplate instead of /etc/motd directly

echo "######## $0 ########" | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/bin/date | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/bin/freebsd-version -ku | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
/usr/sbin/freebsd-update --not-running-from-cron fetch | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1
#are updates needed?
/usr/bin/tail -1 /var/log/freebsd-update.log | /usr/bin/grep "No updates needed to update system"
#no
if [ X$? = "X0" ] ; then
  echo done ;
  exit 0 ;        # exit right here, and skip reboot
fi
#yes
/usr/sbin/freebsd-update --not-running-from-cron install | /usr/bin/tee -a /var/log/freebsd-update.log 2>&1

#update motd.template
NEWVERSION=`/bin/freebsd-version -u`
/bin/cat /etc/motd.template| sed -e "s/^System:.*$/System: ${NEWVERSION}/g" >/etc/motd.template.new
/bin/mv /etc/motd.template.new /etc/motd.template
/bin/echo "/etc/motd.template has been updated to ${NEWVERSION}"

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

exit 0;
###EOF script
