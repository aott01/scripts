#!/bin/sh

# andreas, Wed Oct 29 09:34:47 PDT 2014
# quick hack to add domains (or IP prefixes) to access.db
# Tue Apr  1 19:28:41 UTC 2025
#   up to FOUR cmd line args, yes this is for /22 offenders

cd /etc/mail

/usr/bin/grep -n ^$1 access
echo -n $1 " "
echo -n $1 >>access
echo "          ERROR:\"550 we don't like spam here\"" >>access

# second cli arg
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
  echo -n $3 " "
  echo -n $3 >>access
  echo "          ERROR:\"550 we don't like spam here\"" >>access
else
  echo
fi

# fourth cli arg
if [ "x$4" != "x" ] ; then
  /usr/bin/grep -n ^$4 access ;
  echo $4 
  echo -n $4 >>access
  echo "          ERROR:\"550 we don't like spam here\"" >>access
else
  echo
fi

/usr/bin/make
/bin/date
###EOF
