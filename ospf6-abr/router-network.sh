#!/bin/bash


echo "8021q"> /etc/modules
echo "
auto eth1.$2                                              
iface eth1.$2 inet6 static
  address $1/64        
  vlan-raw-device eth1 
  up ip link set eth1.$2 mtu 1400"> /etc/network/interfaces.d/vlan
  

sudo modprobe 8021q
sudo systemctl restart networking
sudo apt update
sudo apt install -y frr

sed -i 's/ospf6d=.*/ospf6d=true/g' /etc/frr/daemons

echo "
frr version 8.4.4
frr defaults traditional
hostname router1
log syslog informational
no ip forwarding
no ipv6 forwarding
service integrated-vtysh-config
!
interface eth1.$2
 ipv6 address fd00:$2::2000/64
 ipv6 ospf6 area $3
exit
!
router ospf6
 ospf6 router-id 10.10.10.$2
 area $3 range fd00:$2::/64
exit
!
"> /etc/frr/frr.conf

sudo systemctl restart frr