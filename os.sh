#!/usr/bin/env bash
hosts_file='/etc/hosts'
opts='-p 22 -t -C -4 -o StrictHostKeyChecking=no'
   
ip='192.168.50.4'
hosts=($(mysql -h ${ip} -uidcube --password=idcube  idcube \
    -se "select hostname from host"|cat))
ipv4=($(mysql -h ${ip} -uidcube --password=idcube  idcube \
    -se "select ipv4 from host"|cat))

length=${#hosts[@]}
for (( i = 0; i < $length; i++ )); do
    echo ${ipv4[i]} ${hosts[i]} >> $hosts_home
done

for (( i = 0; i < ${length} i++ )); do
    scp ${opts} $hosts_file root@${ipv4[i]}:${hosts_file} 
done
