#!/bin/sh

# idea from https://arstechnica.com/gadgets/2020/02/how-fast-are-your-disks-find-out-the-open-source-way-with-fio/
set -e

# temp directory for the file blobs
mkdir /tmp/fio-tests
cd /tmp/fio-tests

echo first trial run
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --numjobs=1 --size=4g --iodepth=1 --runtime=60 --time_based --end_fsync=1

echo Single 4KiB random write process
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=4k --size=4g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1

#This is a single process doing random 4K writes. This is where the pain really, really lives; it's basically the worst possible thing you can ask a disk to do. Where this happens most frequently in real life: copying home directories and dotfiles, manipulating email stuff, some database operations, source code trees.

echo 16 parallel 64KiB random write processes
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k --size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based --end_fsync=1

#This time, we're creating 16 separate 256MB files (still totaling 4GB, when all put together) and we're issuing 64KB blocksized random write operations. We're doing it with sixteen separate processes running in parallel, and we're queuing up to 16 simultaneous asynchronous ops before we pause and wait for the OS to start acknowledging their receipt.  This is a pretty decent approximation of a significantly busy system. It's not doing any one particularly nasty thing—like running a database engine or copying tons of dotfiles from a user's home directory—but it is coping with a bunch of applications doing moderately demanding stuff all at once.

echo Single 1MiB random write process
fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=1m --size=16g --numjobs=1 --iodepth=1 --runtime=60 --time_based --end_fsync=1

#This is pretty close to the best-case scenario for a real-world system doing real-world things. No, it's not quite as fast as a single, truly contiguous write... but the 1MiB blocksize is large enough that it's quite close. Besides, if literally any other disk activity is requested simultaneously with a contiguous write, the "contiguous" write devolves to this level of performance pretty much instantly, so this is a much more realistic test of the upper end of storage performance on a typical system.

# cleanup temp directory
cd /tmp/
rm -rf /tmp/fio-tests
