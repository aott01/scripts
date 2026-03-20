SOURCEIP="192.168.100.2,192.0.2.66""

#allow localhost
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
#allow established
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#allow from SOURCEIP
iptables -A INPUT -p tcp -s ${SOURCEIP} --dport 22 -m conntrack --ctstate NEW -j ACCEPT
# log and drop all others
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j LOG --log-prefix "iptables_ssh_log_drop: "
iptables -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW -j DROP
