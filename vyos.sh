#!/bin/bash
#IP de vclass
IP_extremo=sudo docker exec -it  mn.dc1_vcpe-1-1-ubuntu-1 hostname -I | tr " " "\n" | grep 192.168.100
echo "$IP_extremo"
sudo ovs-docker add-port ExtNet eth2 mn.dc1_vcpe-1-2-vyos-1
docker exec -ti mn.dc1_vcpe-1-2-vyos-1 /bin/bash -c "
source /opt/vyatta/etc/functions/script-template
configure

#Configuración del tunel vxlan, extremo del vcpe
set interfaces vxlan vxlan1 address 192.168.255.1/24
set interfaces vxlan vxlan1 remote $(sudo docker exec -it  mn.dc1_vcpe-1-1-ubuntu-1 hostname -I | tr " " "\n" | grep 192.168.100)
set interfaces vxlan vxlan1 port 8472
set interfaces vxlan vxlan1 vni 1
set interfaces vxlan vxlan1 mtu 1400

#Configuración DHCP
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 default-router '192.168.255.1'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 dns-server '192.168.255.1'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 domain-name 'vyos.net'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 lease '86400'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 range 0 start 192.168.255.20
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 range 0 stop '192.168.255.254'

#ConfiguracióN DNS
set service dns forwarding cache-size '0'
set service dns forwarding listen-address '192.168.255.1'
set service dns forwarding allow-from '192.168.255.0/24'

# Configuración NAT
set nat source rule 100 outbound-interface 'eth2'
set nat source rule 100 source address '192.168.255.0/24'
set nat source rule 100 translation address masquerade

#Configuración salida exterior
set interfaces ethernet eth2 address 10.2.3.1/24
set interfaces ethernet eth2 mtu 1400
set interfaces ethernet eth0 disable
set protocols static route 0.0.0.0/0 next-hop 10.2.3.254 distance '1'


commit
save
exit 
"

IP_extremo=sudo docker exec -it  mn.dc1_vcpe-2-1-ubuntu-1 hostname -I | tr " " "\n" | grep 192.168.100
echo "$IP_extremo"
sudo ovs-docker add-port ExtNet eth2 mn.dc1_vcpe-2-2-vyos-1
docker exec -ti mn.dc1_vcpe-2-2-vyos-1 /bin/bash -c "
source /opt/vyatta/etc/functions/script-template
configure

#Configuración del tunel vxlan, extremo del vcpe
set interfaces vxlan vxlan1 address 192.168.255.1/24
set interfaces vxlan vxlan1 remote $(sudo docker exec -it  mn.dc1_vcpe-2-1-ubuntu-1 hostname -I | tr " " "\n" | grep 192.168.100)
set interfaces vxlan vxlan1 port 8472
set interfaces vxlan vxlan1 vni 1
set interfaces vxlan vxlan1 mtu 1400

#Configuración DHCP
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 default-router '192.168.255.1'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 dns-server '192.168.255.1'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 domain-name 'vyos.net'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 lease '86400'
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 range 0 start 192.168.255.20
set service dhcp-server shared-network-name LAN subnet 192.168.255.0/24 range 0 stop '192.168.255.254'

#ConfiguracióN DNS
set service dns forwarding cache-size '0'
set service dns forwarding listen-address '192.168.255.1'
set service dns forwarding allow-from '192.168.255.0/24'

# Configuración NAT
set nat source rule 100 outbound-interface 'eth2'
set nat source rule 100 source address '192.168.255.0/24'
set nat source rule 100 translation address masquerade

#Configuración salida exterior
set interfaces ethernet eth2 address 10.2.3.2/24
set interfaces ethernet eth2 mtu 1400
set interfaces ethernet eth0 disable
set protocols static route 0.0.0.0/0 next-hop 10.2.3.254 distance '1'


commit
save
exit 
"

