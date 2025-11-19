#!/bin/bash
#
#blocking offenders from SYN flooding port 443 (apache2)
#
TMPFILE=`mktemp`
echo INFO: this host uses fail2ban, first two lines of iptables INPUT chain are taken, hence inject at line 3
echo INFO: otherwise inject at line 1 of INPUT chain
iptables -nvL |head -10
# remove lines that caught nothing since they were added
for i in `iptables -nvL|grep ^....0.*tcp.dpt:443.state.NEW |awk '{print $8}'`; do
        echo iptables -D INPUT  -p tcp --dport 443 -m state --state NEW -j DROP -s ${i}
  done
# check for any SYN_ connections...
if (netstat -na | grep :443.*SYN_) ; then
  echo INFO: found some SYN_ offenders, sorting by /24
  netstat -na |grep :443.*SYN_|awk '{print $5}'|sed -s 's/\.[0-9]*:.*$//g'|sort | uniq -c |sort -rn
  echo INFO: offending blocks from whois lookup, need to throttle lookups
  for b in `netstat -na |grep :443.*SYN_|awk '{print $5}'|sed -s 's/\.[0-9]*:.*$//g'|sort | uniq -c | sort -rn |awk '{print $2}'` ; do
    whois $b.1 | egrep inetnum\|aut-num >> ${TMPFILE}
    sleep 1
    done
  cat ${TMPFILE}
  echo INFO: sorted and unique, ready to block
  for b in `cat ${TMPFILE} |grep inetnum| cut -d: -f 2 |sort|uniq `; do
  # check for prefix/netmask of block, formatting in whois output is not uniform
    if [[ "${b}" == *"0/"* ]]; then
      echo INFO: ADDING iptables -I INPUT 3 -p tcp --dport 443 -m state --state NEW -j DROP -s ${b}
      iptables -I INPUT 3 -p tcp --dport 443 -m state --state NEW -j DROP -s ${b}
    else
      echo WARNING: check format of prefix/netmask from whois
    fi
    done
fi
echo INFO: iptables
iptables -nvL |head -20
# cleanup
rm -f ${TMPFILE}
exit 0
