#!/bin/bash

docker build -t snmp . && docker run -d --name SNMP --hostname snmp -p 162:162/udp snmp
sleep 2
docker ps
sleep 0.5
docker exec -it SNMP bash
