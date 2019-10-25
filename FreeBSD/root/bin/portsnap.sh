#!/bin/sh

# $Id: portsnap.sh,v 1.1 2018/10/10 18:47:54 andreas Exp $

/usr/sbin/portsnap fetch 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1
#only one time
#/usr/sbin/portsnap extract 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1
#after that update only
/usr/sbin/portsnap update 2>&1 | /usr/bin/tee -a /var/log/portsnap.log 2>&1

/usr/bin/logger $0 completed
exit 0
###EOF script
