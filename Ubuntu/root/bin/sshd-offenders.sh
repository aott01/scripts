#!/bin/sh

journalctl |grep sshd.*Failed|awk -F"from" '{print $2}' |sed -e 's/ port.*//g' |sort |uniq -c|sort -n
