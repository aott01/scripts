#!/bin/bash
#
#blocking offenders from SYN flooding port 443 (apache2)
#
TMPFILE=`mktemp`

#echo "INFO: if this host uses fail2ban, first N lines of iptables INPUT chain are already taken, hence inject at line N+1"
#echo "INFO: otherwise inject at line 1 of INPUT chain"
LINEF2B=`iptables -L INPUT --line-numbers -n | egrep -e 'f2b-|SPAMHAUS_DROP' | tail -1 | sed '/^num\|^$\|^Chain/d' | awk '{print $1}'`
NEXTRULE=$((LINEF2B + 1))

# remove lines that caught zero since they were added
for i in `/usr/sbin/iptables -nvL|grep ^"    0".*tcp.dpt:443.state.NEW |awk '{print $8}'`; do
        /usr/sbin/iptables -D INPUT  -p tcp --dport 443 -m state --state NEW -j DROP -s ${i}
        /usr/bin/logger -t $0 "REMOVED from iptables chain INPUT DROP tcp/443 line for ${i}"
  done
# check for any SYN_ connections...
if (netstat -na | grep :443.*SYN_) ; then
  echo "INFO: found some SYN_ offenders, sorting by /24"
  netstat -na |grep :443.*SYN_|awk '{print $5}'|sed -s 's/\.[0-9]*:.*$//g'|sort | uniq -c |sort -rn
  echo "INFO: offending blocks from whois lookup, need to throttle lookups"
  for b in `netstat -na |grep :443.*SYN_|awk '{print $5}'|sed -s 's/\.[0-9]*:.*$//g'|sort | uniq -c | sort -rn |awk '{print $2}'` ; do
    whois $b.1 | egrep inetnum\|aut-num >> ${TMPFILE}
    sleep 1
    done
  cat ${TMPFILE}
  echo "INFO: sorted and unique, ready to block"
  for b in `cat ${TMPFILE} |grep inetnum| cut -d: -f 2 |sort|uniq `; do
  # check for prefix/netmask of block, formatting in whois output is not uniform
  # only insert prefix/netmask if not already present
  if [[ "${b}" == *"0/"* ]] && [[ $(iptables -nvL | grep -L "${b}.*tcp.dpt:443.state.NEW" - ) ]] ; then
      echo "INFO: ADDING iptables -I INPUT 3 -p tcp --dport 443 -m state --state NEW -j DROP -s ${b}"
      /usr/sbin/iptables -I INPUT ${NEXTRULE} -p tcp --dport 443 -m state --state NEW -j DROP -s ${b}
      /usr/bin/logger -t $0 "ADDED iptables -I INPUT ${NEXTRULE} -p tcp --dport 443 -m state --state NEW -j DROP -s ${b}"
    else
      echo "WARNING: check format of prefix/netmask from whois"
    fi
    done
fi
echo "INFO: current iptables (first 20 lines)"
/usr/sbin/iptables -nvL |head -20
# cleanup
rm -f ${TMPFILE}
exit 0
