echo WARNING: the device name has been set to /dev/sdzz (Linux "SCSI" hard drive number 26*26), but use this at your own risk.
echo Once lost, you data cannot be recovered, it is lost FOREVER! This is the point of running the script.

date
exit 1


# working on CentOS7.6.1810 VM
# log disk info
# from smartmontools-6.5-1.el7.x86_64
/sbin/smartctl -i /dev/sdzz  >> /tmp/somefile.log

# operate on (partition or) on *entire disk* device?

# generic dd: random fill once, blank once, no verify
# time /bin/dd if=/dev/urandom of=/dev/sdzz bs=1M
# time /bin/dd if=/dev/zero of=/dev/sdzz bs=4096

# from coreutils-8.22-23.el7.x86_64
# time /bin/shred -vfz -n 3 /dev/sdzz

# from nwipe-0.24-2.el7.x86_64
# time /bin/nwipe -m dod522022m -l /tmp/nwipe.log -p mersenne -r 1 /dev/sdzz

# from scrub-2.5.2-7.el7.x86_64
# time /bin/scrub -p dod /dev/sdzz -f


# working on FreeBSD
# generic dd
# ports sysutils/diskscrub
#       security/wipe

exit 0
###EOF

### Example output from runs, using virtual machine 32GB disk (thick provisioned, eagerly zereoed)

# time /bin/dd if=/dev/urandom of=/dev/sdc bs=1M
/bin/dd: error writing ?/dev/sdc?: No space left on device
32769+0 records in
32768+0 records out
34359738368 bytes (34 GB) copied, 135.73 s, 253 MB/s

real   2m15.732s
user   0m0.023s
sys    2m14.617s

# date ; time /bin/dd if=/dev/zero of=/dev/sdc bs=4096 ; date
Sat Aug 17 17:41:55 UTC 2019
/bin/dd: error writing ?/dev/sdc?: No space left on device
8388609+0 records in
8388608+0 records out
34359738368 bytes (34 GB) copied, 125.052 s, 275 MB/s

real   2m5.053s
user   0m2.647s
sys    0m28.763s
Sat Aug 17 17:44:00 UTC 2019

###
[...]
/bin/shred: /dev/sdc: pass 4/4 (000000)...27GiB/32GiB 84%
/bin/shred: /dev/sdc: pass 4/4 (000000)...28GiB/32GiB 87%
/bin/shred: /dev/sdc: pass 4/4 (000000)...29GiB/32GiB 90%
/bin/shred: /dev/sdc: pass 4/4 (000000)...30GiB/32GiB 93%
/bin/shred: /dev/sdc: pass 4/4 (000000)...31GiB/32GiB 96%
/bin/shred: /dev/sdc: pass 4/4 (000000)...32GiB/32GiB 100%

real   13m15.142s
user   1m31.936s
sys    0m33.463s
Sat Aug 17 17:59:29 UTC 2019


###
nwipe looks like dban (curses full screen), real time skewed by having to press enter to exit
[...]
/dev/sdc - VMware Virtual disk
   (success) [261 MB/s]
                         Wipe finished - press enter to exit. Logged to /tmp/nwipe.log
real   23m55.776s
user   2m41.342s
sys    4m26.470s
Sat Aug 17 18:29:08 UTC 2019

###
# date ; time /bin/scrub -p dod /dev/sdc -f ; date
Mon Aug 19 16:34:06 UTC 2019
scrub: using DoD 5220.22-M patterns
scrub: please verify that device size below is correct!
scrub: scrubbing /dev/sdc 34359738368 bytes (~32GB)
scrub: random  |................................................|
scrub: 0x00    |................................................|
scrub: 0xff    |................................................|
scrub: verify  |................................................|

real   8m43.348s
user   2m27.356s
sys    0m13.669s
Mon Aug 19 16:42:50 UTC 2019
