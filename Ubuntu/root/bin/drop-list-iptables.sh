#!/bin/bash

# Define the URL for the Spamhaus DROP list (IPv4)
DROP_URL="https://www.spamhaus.org/drop/drop_v4.json"

# Define a specific iptables chain to manage the rules (recommended)
CHAIN_NAME="SPAMHAUS_DROP"

# Clear existing rules in the custom chain and delete the chain if it exists
iptables -F $CHAIN_NAME 2>/dev/null
iptables -X $CHAIN_NAME 2>/dev/null

# Create a new custom iptables chain
iptables -N $CHAIN_NAME

# Download the list and use jq to extract CIDRs and add rules
#echo "Downloading and parsing Spamhaus DROP list..."
#curl -s $DROP_URL | jq -r '.[].cidr' | while read CIDR_BLOCK; do
echo "Parsing and processing Spamhaus DROP list... file already downloaded with wget"
cat /root/drop_v4.json | jq -r '.cidr' | grep -v null| while read CIDR_BLOCK; do
    if [ ! -z "$CIDR_BLOCK" ]; then
        echo "Adding DROP rule for: $CIDR_BLOCK"
        # Add a DROP rule for each CIDR block in the custom chain
        iptables -A $CHAIN_NAME -s $CIDR_BLOCK -j DROP
    fi
done
# add RETURN rule with comment of timestamp of ruleset
TIMESTAMP=`cat /root/drop_v4.json | jq -r .timestamp |grep -v null`
THEN=`LANG=C date -d @${TIMESTAMP}`
iptables -A $CHAIN_NAME -s 0.0.0.0/0 -j RETURN -m comment --comment "updated ${THEN}"

echo "Spamhaus DROP list rules applied to iptables chain $CHAIN_NAME."

# Insert a rule into the INPUT chain to jump to the custom chain
# Adjust INPUT to FORWARD or other chains as needed for your specific setup
echo "just build table/chain "
#iptables -I INPUT 1 -j $CHAIN_NAME

# Make the iptables rules persistent with
# Debian/Ubuntu: sudo netfilter-persistent save
