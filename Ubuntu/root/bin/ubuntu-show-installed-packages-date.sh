#!/bin/sh

# from https://unix.stackexchange.com/questions/12578/list-packages-on-an-apt-based-system-by-installation-date
# looks back into dpkg log files (beware of logrotate and aging out)

for x in $(ls -1t /var/log/dpkg.log*); do zcat -f $x |tac |grep -e " install " -e " upgrade " -e " remove "; done |awk -F ":a" '{print $1 " :a" $2}' |column -t |less

for file_list in `ls -rt /var/lib/dpkg/info/*.list`; do \
    stat_result=$(stat --format=%y "$file_list"); \
    printf "%-50s %s\n" $(basename $file_list .list) "$stat_result"; \
done | less
