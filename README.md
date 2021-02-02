1. Crear los switches "externos" a OSM: AccessNet y ExtNet
./init.sh

2. Comprobar que vim-emu est arrancado y sino arrancarlo
osm-check-vimemu
osm-restart-vimemu

3. Crear las imagenes de los docker
cd img/vnf-vyos
sudo docker build -t vnf-vyos .
cd ../vnf-img
sudo docker build -t vnf-img .

4. En OSM subir las VNF y NS y lanzar las dos instancias (vcpe-1 y vcpe-2)

5. Arrancar los escenrios de la red residencial y del servidor
sudo vnx -f vnx/nfv3_home_lxc_ubuntu64.xml -t
sudo vnx -f vnx/nfv3_server_lxc_ubuntu64.xml -t

6. Configurar y enlazar el servicio desplegado en OSM con los escenariois VNX
./vcpe-1.sh
./vcpe-2.sh
./vyos.sh

7. Configurar RYU en los vclass
./ryu1
./ryu2

8. Lanzar comandos de calidad de servicio
./curl.sh


# Para acceder a los terminales de la vclass y vyos
Para vcpe-1
sudo docker exec -it mn.dc1_vcpe-1-1-ubuntu-1 bash
sudo docker exec -ti mn.dc1_vcpe-1-2-vyos-1 bash -c 'su - vyos'

Para vcpe-2
sudo docker exec -it mn.dc1_vcpe-2-1-ubuntu-1 bash
sudo docker exec -ti mn.dc1_vcpe-2-2-vyos-1 bash -c 'su - vyos'

#Comprobar que funciona la calidad del servicio
En el lado del servidor (h11/h12...) -> iperf -s -u -i 1
En el lado del cliente (vyos/s1) -> iperf -c 192.168.255.20 -u -b 12M -l 1200