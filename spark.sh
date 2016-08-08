#!/usr/bin/env bash
SPARK_HOME=''
if [ ${SPARK_HOME} != "" ]; then
    hadoop_home='/opt/idagent/services/hadoop/etc/hadoop'
    hive_home='/opt/idagent/services/hive/conf'
    hbase_home='/opt/idagent/services/hbase/conf'
    opts='-p 22 -r -t -C -4 -o StrictHostKeyChecking=no'
    cp -R ${hadoop_home}/hdfs-site.xml ${hadoop_home}/core-site.xml \
        ${hadoop_home}/yarn-site.xml \
        ${hive_home}/hive-site.xml \
        ${hbase_home}/hbase-site.xml ${SPARK_HOME}/conf/
   
    ip='192.168.50.4'
    hosts=($(mysql -h ${ip} -uidcube --password=idcube  idcube \
        -se "select hostname from host where components like '%spark%'"|cat))
    
    length=${#hosts[@]}
    for (( i = 0; i < $length; i++ )); do
         scp ${opts} ${SPARK_HOME}/conf/ root@${host[i]}:${SPARK_HOME}/conf/
    done
fi
