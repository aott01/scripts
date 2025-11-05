#!/bin/sh

# on DB server...
# secret token in env variable

./influxdb3 query --database logdata --token ${TKN} "SELECT * FROM ip ORDER by time"

exit
# influx@slc:~/.influxdb$ ./influxdb3 query --database logdata --token ${TKN} "SELECT * FROM ip ORDER by time"
#+--------------------+---------------------------+-------------------------------------------+-----+---------------------+
#| host               | inet                      | inet6                                     | int | time                |
#+--------------------+---------------------------+-------------------------------------------+-----+---------------------+
#| "aott-mbp22.local" | 10.118.205.119/0xffffff00 | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en6 | 2025-11-05T19:33:52 |
#| "aott-mbp22.local" | 192.168.83.15/0xffffff00  | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en0 | 2025-11-05T19:37:55 |
#| "aott-mbp22.local" | 10.118.205.119/0xffffff00 | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en6 | 2025-11-05T19:37:58 |
#| "aott-mbp22.local" | 192.168.83.15/0xffffff00  | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en0 | 2025-11-05T19:39:12 |
#| "aott-mbp22.local" |                           | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en6 | 2025-11-05T19:39:14 |
#| "aott-mbp22.local" | 192.168.83.15/0xffffff00  | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en0 | 2025-11-05T19:40:14 |
#| "aott-mbp22.local" | 10.118.205.119/0xffffff00 | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en6 | 2025-11-05T19:40:18 |
#| "aott-mbp22.local" | 192.168.83.15/0xffffff00  | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en0 | 2025-11-05T19:45:58 |
#| "aott-mbp22.local" | 10.118.205.119/0xffffff00 | 2601:647:c001:76fc:189f:a2af:acbb:a652/64 | en6 | 2025-11-05T19:46:01 |
#+--------------------+---------------------------+-------------------------------------------+-----+---------------------+
