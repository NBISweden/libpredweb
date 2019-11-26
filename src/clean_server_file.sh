#!/bin/bash

# Clean server files

usage="
USAGE: $0 path_static
"

if [ "$1" == "" ];then
    echo "path_static not supplied!" >&2
    echo "$usage" >&2
    exit 1
fi

path_tmp=$path_static/tmp
path_log=$path_static/log

# 1. clean tmp folder
cd $path_tmp
for dir in $(find . -maxdepth 1 -type d  -ctime +10 -name "tmp_*"  ); do echo "rm -rf $dir"; rm -rf $dir; done

# 2. clean outdated archived log files

cd $path_log
filelist="
qd_fe.py.log
qd_fe.py.err
debug.log
restart_qd_fe.cgi.log
"

for file in $filelist; do
    findlist=$(find . -maxdepth 1 -name "${file}.*.gz")
    if [ "$findlist" != "" ] ; then
        nf=$(echo "$findlist" | wc -l)
        if [ $nf -gt 1 ];then
            ((ndelete=nf-1))
            newlist=`ls -1ahrt $(echo "$findlist") | head -n $ndelete`
            for f in $newlist; do rm -f $f; done
        fi
    fi
done
