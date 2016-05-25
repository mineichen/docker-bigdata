#!/bin/sh
if ! find "/hdfs" -mindepth 1 -print | grep -q .; then
    echo "Format HDFS"
    /usr/local/hadoop/bin/hdfs namenode -format
fi

/usr/local/hadoop/bin/hdfs namenode

