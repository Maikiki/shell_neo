#!/usr/bin/env bash 
ZOOKEEPER_INSTALL='/opt/idagent/services/zookeeper'
if [ ${ZOOKEEPER_INSTALL} != "" ]; then
    conFile=${ZOOKEEPER_INSTALL}/conf/zoo.cfg
    ip='192.168.50.4'
    hosts=($(mysql -h $ip -uidcube --password=idcube  idcube \
        -se "select hostname from host where components like '%quorumpeer%'"|cat))
    length=${#hosts[@]}
    
    for (( i = 0; i < ${length}; i++ )); do
        echo server.$[$i+1]=${hosts[i]}:2888:3888 >>$conFile       
    done
    slaves=($(cat "$conFile"|sed '/^server/!d;s/^.*=//;s/:.*$//g;/^$/d'))
    myids=($(cat "$conFile"|sed '/^server/!d;s/server.//'|cut -c 1)
    dataDir=$(cat "$conFile"|sed '/^dataDir/!d;s/^dataDir=//')

    for (( i=0; i<${length};i++)); do
        ssh ${slaves[i]} "mkdir -p ${dataDir}/myid echo ${myids[i]} > ${dataDir}/myid;\
            scp $conFile root@${slaves[i]}:$conFile"
    done
fi
