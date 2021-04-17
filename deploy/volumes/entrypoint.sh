#!/bin/bash

set -e

# Link all files from volumes to hadoop config directory.
ln -s -f /volumes/hadoop/* $HADOOP_HOME/etc/hadoop/

if [ "$1" = "master" ]; then
  if [ ! -d "/opt/tmp/dfs/name" ]; then
    hdfs namenode -format
  fi
  hdfs namenode &
  mapred historyserver &
  yarn resourcemanager
elif [ "$1" = "worker" ]; then
  hdfs datanode &
  yarn nodemanager
elif [ "$1" = "namenode" ]; then
  if [ ! -d "/opt/tmp/dfs/name" ]; then
    hdfs namenode -format
  fi
  hdfs namenode
elif [ "$1" = "resourcemanager" ]; then
  yarn resourcemanager
elif [ "$1" = "historyserver" ]; then
  mapred historyserver
elif [ "$1" = "datanode" ]; then
  hdfs datanode
elif [ "$1" = "nodemanager" ]; then
  yarn nodemanager
else
  echo "Do not add to cluster."
fi

exec $@
