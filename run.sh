#!/bin/bash
echo "##########################################################"
echo "Bring up Loxone Reporting Stack: Grafana, InfluxDB, unifi-poller and NodeRed incl. loxone and influxdb"
echo
echo "Please make sure, to edit unifi-poller/up.conf!"
echo
echo "InfluxDB is available in NodeRed as 'influxdb'"
echo 
echo "##########################################################"
read -p "Press enter to continue and bring up docker"

docker-compose up -d

echo
echo "Check and create loxone and unifi Database"
curl -G http://localhost:8086/query?pretty=true --data-urlencode "db=glances" --data-urlencode "q=SHOW DATABASES" | grep loxone > /dev/null
unifi=$?
echo $unifi
if [ $unifi -ne "0" ]; then
	echo "create loxone DB"
	curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE loxone'
fi
echo 
curl -G http://localhost:8086/query?pretty=true --data-urlencode "db=glances" --data-urlencode "q=SHOW DATABASES" | grep unifi > /dev/null
loxone=$?
echo $loxone
if [ $loxone -ne "0" ]; then
	echo "create unifi DB"
	curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE unifi'
fi
echo 
curl -G http://localhost:8086/query?pretty=true --data-urlencode "db=glances" --data-urlencode "q=SHOW DATABASES" | grep synology > /dev/null
synology=$?
echo $synology
if [ $synology -ne "0" ]; then
	echo "create synology DB"
	curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE synology'
fi

echo
echo
echo "##########################################################"
echo "Current database list"
curl -G http://localhost:8086/query?pretty=true --data-urlencode "db=glances" --data-urlencode "q=SHOW DATABASES"
echo
echo "##########################################################"

echo
echo
echo

echo "##########################################################"
echo
echo
echo "Grafana: http://127.0.0.1:3000 - admin/admin"
echo "Nodered: http://127.0.0.1:1880"
echo
echo "Create a new database ?"
echo "curl -XPOST 'http://localhost:8086/query' --data-urlencode 'q=CREATE DATABASE mydb'"
