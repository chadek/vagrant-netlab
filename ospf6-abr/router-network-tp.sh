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

sudo systemctl restart frr