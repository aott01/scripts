#!/bin/sh

# clones VM from template
qm clone 111 112 --full --storage=sdb-lvm --name vm-112-ub24clone
