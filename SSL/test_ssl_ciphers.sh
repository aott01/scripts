#!/usr/bin/env bash

# $Id$
# spin-off and improvements from test_cipher.sh script, with checking result code, and TLS versions
# @aott01, Wed Mar 19 00:01:02 UTC 2019

# scripts handles up to two cli arguments: 
#   $1 is IP:port
#   $2 delay in seconds between probes

# change defaults here
# OpenSSL requires the port number, formatted as IP:port, taken from arg $1; default localhost:443
SERVER=${1:-127.0.0.1:443}
# script waits n seconds in between calls, taken from arg $2; default: 0 seconds
DELAY=${2:-0}

# if required point to your own locally compiled version of openssl binary
#OPENSSL=/usr/local/src/openssl-1.1.1b/apps/openssl
OPENSSL=`/usr/bin/which openssl`

# try if we are able to connect to IP at port
TARGET=`/bin/echo ${SERVER}| /usr/bin/sed -e 's/:/ /g'`
/bin/echo trying to connect to ${SERVER}
/usr/bin/nc -w 1 ${TARGET}
if [[ $? > 0 ]] ; then
  echo ${SERVER} unreachable
  exit 1;
fi

echo Using $(${OPENSSL} version)

echo Testing server ${SERVER} with ${DELAY} seconds delay

# insert cipher testing here
ciphers=$(${OPENSSL} ciphers 'ALL:eNULL' | /usr/bin/sed -e 's/:/ /g')

for cipher in ${ciphers[@]}
do

echo -n Testing ${cipher}...
result=$(echo -n | ${OPENSSL} s_client -cipher "${cipher}" -connect ${SERVER} 2>&1)
if [[ "${result}" =~ "Cipher    :" ]] ; then
  echo YES
else
  if [[ "${result}" =~ ":error:" ]] ; then
    error=$(echo -n ${result} | /usr/bin/cut -d':' -f6)
    echo NO \(${error}\)
  else
    echo UNKNOWN RESPONSE
    echo ${result}
  fi
fi

sleep ${DELAY}
done


echo -n Testing for SSLv3... 
result=$(echo -n | ${OPENSSL} s_client -ssl3 -connect ${SERVER} 2>&1) 
if [[ "$result" =~ "SSLv3, Cipher is" ]] ; then 
  echo supported INSECURE
else 
  echo NO, SSLv3 not supported, Test OK 
fi 

/bin/sleep ${DELAY}

echo -n Testing for TLSv1... 
result=$(echo -n | ${OPENSSL} s_client -tls1 -connect ${SERVER} 2>&1) 
if [[ $? > 0 ]] ; then 
  echo connection error: NO, TLSv1 is not supported
else
  if [[ "$result" =~ "Protocol  : TLSv1" ]] ; then 
    echo YES TSLv1 is supported 
  else 
    echo NO, TLSv1 is not supported
  fi 
fi

/bin/sleep ${DELAY}

echo -n Testing for TLSv1.1... 
result=$(echo -n | ${OPENSSL} s_client -tls1_1 -connect ${SERVER} 2>&1) 
if [[ $? > 0 ]] ; then
  echo connection error: NO, TLSv1.1 is not supported
else
  if [[ "$result" =~ "Protocol  : TLSv1.1" ]] ; then 
    echo YES TSLv1.1 is supported 
  else 
    echo NO, TLSv1.1 is not supported
  fi
fi

/bin/sleep ${DELAY}

echo -n Testing for TLSv1.2... 
result=$(echo -n | ${OPENSSL} s_client -tls1_2 -connect ${SERVER} 2>&1) 
if [[ $? > 0 ]] ; then
  echo connection error: NO, TLSv1.2 is not supported
else
  if [[ "$result" =~ "Protocol  : TLSv1.2" ]] ; then 
    echo YES TSLv1.2 is supported 
  else 
    echo NO, TLSv1.2 is not supported
  fi 
fi

/bin/sleep ${DELAY}

echo -n Testing for TLSv1.3...
result=$(echo -n | ${OPENSSL} s_client -tls1_3 -connect ${SERVER} 2>&1)
if [[ $? > 0 ]] ; then
  echo connection error: NO, TLSv1.3 is not supported
else
  if [[ "$result" =~ "Protocol  : TLSv1.3" ]] ; then
    echo YES TSLv1.3 is supported
  else
    echo NO, TLSv1.3 is not supported
  fi
fi

/bin/sleep ${DELAY}

echo -n Testing SSL secure renegotiation... 
echo -n "" | ${OPENSSL} s_client -connect ${SERVER} 2>&1 | grep 'Secure Renegotiation'
