#!/bin/bash

docker images
sleep 0.5
docker ps
sleep 0.5
docker ps -a
sleep 0.5

docker stop SNMP
docker rm SNMP
docker rmi snmp
