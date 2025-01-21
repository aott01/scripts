#!/bin/sh

# andreas, Wed Oct 29 09:34:47 PDT 2014
# quick hack to add domain (and IP prefix) to access.db on FreeBSD sendmail in /etc/mail/
# db will error out on duplicate values, therefore grep if value is already present
# Fri Jan 22 18:00:51 UTC 2016
#   up to three cmd line args

cd /etc/mail

/usr/bin/grep -n ^$1 access
echo -n $1 " "
echo -n $1 >>access
echo "          ERROR:\"550 we don't like spam here\"" >>access

if [ "x$2" != "x" ] ; then
  /usr/bin/grep -n ^$2 access ;
  echo -n $2 " "
  echo -n $2 >>access
  echo "          ERROR:\"550 we don't like spam here\"" >>access
else
  echo
  /usr/bin/make
  exit 0
fi

# third cli arg
if [ "x$3" != "x" ] ; then
  /usr/bin/grep -n ^$3 access ;
  echo $3
  echo -n $3 >>access
  echo "          ERROR:\"550 we don't like spam here\"" >>access
else
  echo
fi

/usr/bin/make
/bin/date
###EOF
