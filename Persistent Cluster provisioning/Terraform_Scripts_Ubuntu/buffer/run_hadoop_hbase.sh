#!/bin/bash

RED='\033[0;31m'
NC='\033[0m'

echo -e "${RED}-------------------Starting hadoop-------------------------------------------------------${NC}"
# command start-all.sh
command /opt/Hadoop/hadoop-3.2.2/sbin/start-dfs.sh
command /opt/Hadoop/hadoop-3.2.2/sbin/start-yarn.sh

echo -e "${RED}-------------------Starting HBase--------------------------------------------------------${NC}"
command /opt/HBase/hbase-2.3.6/bin/start-hbase.sh
