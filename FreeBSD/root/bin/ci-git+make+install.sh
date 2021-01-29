#!/bin/sh

### new file, $Id$

### andreas@naund.org
### originally based on cvsup+compile.sh (2002)
### andreas, Thu Sep 13 21:09:16 UTC 2012
### using SVN to update /usr/src , cvs is gone
### andreas, Thu Jan  4 07:17:02 UTC 2018
### automation and continuous integration are here, make this script run (almost) unattended
###     + 12 Current, logging to /var/log, use onboard svnlite, tests
### andreas, Tue Dec 22 22:59:22 UTC 2020
### FreeBSD moved to git from subversion (pkg git-lite)
###     checkout source into /usr/freebsd-src
###     + pkg update (after lib update)

IFS=' '
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin"

SMPCOMPILE='-j 4'

DELAY=$1
[ -z $1 ] && DELAY=`/usr/bin/od -A n -t d -N 1 /dev/urandom | /usr/bin/tr -d ' '`
/bin/echo randomized 1 Byte delay timer: ${DELAY} seconds
/bin/sleep ${DELAY}
/bin/date

# invoke self-destruction and explode if something goes wrong
set -e

# 0. clean up to make room
#    get rid of old junk first
#    really remove old objects, do not rely on 'make' to actually do the trick
cd /usr/obj
set +e
/bin/chflags -R noschg *
set -e
/bin/rm -rf *
# also forecefully remove old temproot
/bin/rm -rf /var/tmp/temproot/

# 1. get all sources and updates via git (pkg 'git-lite')
cd /usr/
# ONLY ONCE for full clone
/bin/echo "now checking out source via git clone, log written to /var/log/ci-git-clone.log ..."
#/usr/local/bin/git clone https://git.freebsd.org/src.git -b main freebsd-src 2>&1 |/usr/bin/tee -a /var/log/ci-git-clone.log

# LATER JUST UPDATE
cd /usr/freebsd-src
/bin/echo "now updating source update via git pull, log written to /var/log/ci-git-pull.log ..."
/usr/local/bin/git pull --ff-only 2>&1 |/usr/bin/tee -a /var/log/ci-git-pull.log

# 2. now compile source and kernel, even install kernel
# read this
#/usr/bin/less /var/log/ci-git-clone.log
#/usr/bin/less /var/log/ci-git-pull.log
#/usr/bin/less /usr/freebsd-src/README
#/usr/bin/less /usr/freebsd-src/UPDATING

# compile breaks if the compiler toolchain is too old for the recent source,
# e.g. it has been too long since last update from source,
# in that case re-order manually: make buildworld, make installworld, make buildkernel

# compile from newly updated source, mergemaster -p first
/bin/rm -f /var/log/ci-make-buildworld
/bin/rm -f /var/log/ci-make-buildkernel
/bin/rm -f /var/log/ci-make-install
/bin/rm -f /var/log/ci-make-installkernel
/bin/rm -f /var/log/ci-make-installworld
/bin/rm -f /var/log/ci-pkg-update
/bin/rm -f /var/log/ci-pkg-upgrade
cd /usr/freebsd-src
echo "running newvers.sh"
/bin/sh -e /usr/freebsd-src/sys/conf/newvers.sh | /usr/bin/tee -a /var/log/ci-make-buildworld 2>&1
echo "running mergemaster -p"
/usr/sbin/mergemaster -p  | /usr/bin/tee -a /var/log/ci-make-buildworld 2>&1
/bin/rm -rf /var/tmp/temproot/ | /usr/bin/tee -a /var/log/ci-make-buildworld 2>&1
BW_START=`/bin/date`
/usr/bin/make buildworld ${SMPCOMPILE}  | /usr/bin/tee -a /var/log/ci-make-buildworld 2>&1
BK_START=`/bin/date`
/usr/bin/make buildkernel KERNCONF=GENERIC  | /usr/bin/tee -a /var/log/ci-make-buildkernel 2>&1
#    and install new kernel
IK_START=`/bin/date`
/usr/bin/make installkernel INSTALL_NODEBUG=yes KERNCONF=GENERIC  | /usr/bin/tee -a /var/log/ci-make-installkernel 2>&1

# do not reboot at this time, presume the new kernel is fine, proceed
# to GO and collect $200, then make installworld
# this is different from what's in the handbook at
# http://www.freebsd.org/doc/en_US.ISO8859-1/books/handbook/makeworld.html

# 3. make installworld
cd /usr/freebsd-src
IW_START=`/bin/date`
/usr/bin/make installworld | /usr/bin/tee -a /var/log/ci-make-installworld 2>&1
/bin/echo "buildworld started at    ${BW_START}" | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/echo "buildkernel started at   ${BK_START}" | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/echo "installkernel started at ${IK_START}" | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/echo -n "compile and installkernel done at " | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/date | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/echo "installworld started at    ${IW_START}" | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/echo -n "installworld done at " | /usr/bin/tee -a /var/log/ci-make-install 2>&1
/bin/date | /usr/bin/tee -a /var/log/ci-make-install 2>&1

# 4. now do mergemaster
#        echo "Please be careful while running mergemaster."
        echo "HINT: when merging, newer \$FreeBSD version/tag is on the RIGHT"
        echo "      and your old locally modified version is on the LEFT"
#        read -p "Ready to run mergemaster? [NO|yes] "
#        if [ ${REPLY:=NO} = "yes" ] ; then
                echo "saving old /etc directory to /etc.old"
                /bin/sleep 1
                /bin/rm -f /etc.old/unbound
                /bin/cp -RHp /etc/ /etc.old
# ISSUES: yes is not helping if the answer is 'd'; sending log to tee will prevent interactive input
#                /usr/bin/yes | /usr/sbin/mergemaster -U -i -F --run-updates=always | \
#                       /usr/bin/tee -a /var/log/ci-make-install 2>&1
                /usr/sbin/mergemaster -U -i -F --run-updates=always | \
                        /usr/bin/tee -a /var/log/ci-make-install 2>&1
#        fi # 4.

# 5. /etc/mail
echo "Now updating in /etc/mail" | /usr/bin/tee -a /var/log/ci-make-install 2>&1
cd /etc/mail
/usr/bin/make install | /usr/bin/tee -a /var/log/ci-make-install 2>&1

# 6. delete old stuff
rm -f /var/log/ci-make-delete
cd /usr/freebsd-src
/usr/bin/yes|/usr/bin/make delete-old | /usr/bin/tee -a /var/log/ci-make-delete 2>&1
/usr/bin/yes|/usr/bin/make delete-old-libs | /usr/bin/tee -a /var/log/ci-make-delete 2>&1
/usr/bin/yes|/usr/bin/make delete-old-dirs | /usr/bin/tee -a /var/log/ci-make-delete 2>&1

# 7. after deleting stuff, update packages (yo, missing libs anyone?)
/usr/sbin/pkg update -f | /usr/bin/tee -a /var/log/ci-pkg-update 2>&1
/usr/sbin/pkg upgrade -y | /usr/bin/tee -a /var/log/ci-pkg-upgrade 2>&1

# 8. tests
cd /usr/tests/
rm -f /var/log/ci-test
/usr/local/bin/kyua test -k /usr/tests/Kyuafile | /usr/bin/tee -a /var/log/ci-test 2>&1
# delete test logs older than 3 days
/usr/bin/find /root/.kyua/store/ -type f -atime +3 -exec rm -f \{\} \;
# compress log files older than 30 days
/usr/bin/find /root/.kyua/logs/ -type f \! -name \*xz -atime +30 -exec xz \{\} \;

# 9. finally, time to reboot
echo "Time for your automated reboot after upgrading."
date
exec /sbin/fastboot

# obviously we did not reboot if we got here, exiting with error
exit 1;
###EOF script
