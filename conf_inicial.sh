#!/bin/bash

./init.sh

cd img/vnf-vyos
sudo docker build -t vnf-vyos .
echo "Imagen vyos creada"
sleep 5

cd ../vnf-img
sudo docker build -t vnf-img .
echo "Imagen vclass creada"
sleep 5

cd ../..
osm nfpkg-create vnf-vclass.tar.gz 
osm nfpkg-create vnf-vcpe.tar.gz 
#osm nfpkg-list

osm nspkg-create ns-vcpe.tar.gz 
osm ns-create --ns_name vcpe-1 --nsd_name vCPE --vim_account emu-vim
sleep 5
osm ns-create --ns_name vcpe-2 --nsd_name vCPE --vim_account emu-vim
#osm ns-list
echo "Instancias desplegadas"


