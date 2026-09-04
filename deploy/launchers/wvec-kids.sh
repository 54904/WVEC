#!/bin/bash

source /usr/local/etc/ydb_env_set
export ydb_nocenable=1
export ydb_gbldir=/home/ubuntu/wvbuild/VistA-Source/gld/vista.gld
export ydb_routines="/home/ubuntu/wvbuild/VistA-Source/o/utf8*(/home/ubuntu/wvbuild/VistA-Source/r) /usr/local/lib/yottadb/r206/utf8/libyottadbutil.so"

exec $ydb_dist/mumps -run WVECKSTART
