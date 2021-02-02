#!/bin/bash

VNF1="mn.dc1_vcpe-1-1-ubuntu-1"

sudo docker exec -it $VNF1 curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
sudo docker exec -it $VNF1 curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://localhost:8080/qos/queue/0000000000000001
sudo docker exec -it $VNF1 curl -X POST -d '{"match": {"dl_dst": "02:fd:00:04:00:01", "dl_type":"IPv4"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001
sudo docker exec -it $VNF1 curl -X POST -d '{"match": {"dl_dst": "02:fd:00:04:01:01", "dl_type":"IPv4"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
sudo docker exec -it $VNF1 curl -X GET http://localhost:8080/qos/rules/0000000000000001

VNF2="mn.dc1_vcpe-2-1-ubuntu-1"

sudo docker exec -it $VNF2 curl -X PUT -d '"tcp:127.0.0.1:6632"' http://localhost:8080/v1.0/conf/switches/0000000000000001/ovsdb_addr
sudo docker exec -it $VNF2 curl -X POST -d '{"port_name": "vxlan1", "type": "linux-htb", "max_rate": "12000000", "queues": [{"max_rate": "4000000"}, {"min_rate": "8000000"}]}' http://localhost:8080/qos/queue/0000000000000001
sudo docker exec -it $VNF2 curl -X POST -d '{"match": {"dl_dst": "02:fd:00:04:03:01", "dl_type": "IPv4"}, "actions":{"queue": "1"}}' http://localhost:8080/qos/rules/0000000000000001
sudo docker exec -it $VNF2 curl -X POST -d '{"match": {"dl_dst": "02:fd:00:04:04:01", "dl_type": "IPv4"}, "actions":{"queue": "0"}}' http://localhost:8080/qos/rules/0000000000000001
sudo docker exec -it $VNF2 curl -X GET http://localhost:8080/qos/rules/0000000000000001
