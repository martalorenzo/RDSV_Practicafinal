#!/bin/bash

sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -t
sleep 5
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml -t
sleep 5

./vcpe-1.sh
./vcpe-2.sh
./vyos.sh