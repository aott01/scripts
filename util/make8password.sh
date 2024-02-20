#!/bin/sh

# Mon Feb  5 08:44:38 PST 2018
# some tr options are OS specific

export LC_CTYPE=C
export LANG=C

# cmdline args: $1 length
if [ -z $1 ] ; then
  echo Info: no CLI arg supplied for password length, using default length 12
  len=12
 else
  len=$1
fi

echo ====alnum====
/usr/bin/tr -cd '[:alnum:]' < /dev/urandom |  /usr/bin/fold -w${len}| head -8
echo ====alnum plus 30====
/usr/bin/tr -cd '[:alnum:].,/<>?;:{}|!@#$%^&*()-_=+`~[]\\' < /dev/urandom |  /usr/bin/fold -w${len}| head -8
echo ====alnum plus 21====
/usr/bin/tr -cd '[:alnum:].,/<>?;:|!@#$%^&*-_=+' < /dev/urandom |  /usr/bin/fold -w${len}| head -8
echo

echo 32 byte API key upper+digit
/usr/bin/tr -cd '[:upper:][:digit:]' < /dev/urandom |  /usr/bin/fold -w32 | head -8

# if needed, convert to hex
# echo Aa|hexdump -v
#	0000000 6141 000a                              
#	0000003
# and convert back
# echo -e "\x41\x61\x41\x61"
#	AaAa
###EOF
