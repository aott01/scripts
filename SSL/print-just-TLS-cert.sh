#!/bin/sh

# $1 server IP or hostname

echo |openssl s_client  -connect $1:443 2>&1 |sed -n '/^-----/,/-----$/p'
