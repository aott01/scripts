#!/bin/sh

source ./.env

HOST=$(hostname)

for i in en0 en6; do
NOW=$(date +%s)
INET=$(ifconfig $i |grep inet\ |awk '{print $2"/"$4}')
  INET=${INET:-"none"} # default if empty
INET6=$(ifconfig $i|grep inet6.\*autoconf.secured|awk '{print $2"/"$4}')
  INET6=${INET6:-"none"} # default if empty
curl "${INDBSERVER}/api/v3/write_lp?db=${DB}" \
  --header "Authorization: Bearer ${TKN}" \
  --data-raw "ip,host=\"${HOST}\" int=\"${i}\",inet=\"${INET}\",inet6=\"${INET6}\" ${NOW}"
sleep 1
done
