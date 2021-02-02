#!/bin/bash

VNF1="mn.dc1_vcpe-1-1-ubuntu-1"

sudo docker exec -it $VNF1 ovs-vsctl set bridge br0 protocols=OpenFlow13
sudo docker exec -it $VNF1 ovs-vsctl set bridge br0 other-config:datapath-id=0000000000000001
sudo docker exec -it $VNF1 ovs-vsctl set-controller br0 tcp:127.0.0.1:6633
sudo docker exec -it $VNF1 ovs-vsctl set-manager ptcp:6632
sudo docker exec -it $VNF1 ryu-manager ryu.app.rest_qos ryu.app.rest_conf_switch ./qos_simple_switch_13.py 




