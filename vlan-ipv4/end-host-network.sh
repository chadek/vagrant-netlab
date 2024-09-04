#!/bin/bash

echo "8021q"> /etc/modules
echo "
auto eth1.$2                                              
iface eth1.$2 inet4 static
  address $1/24
  gateway 10.0.$2.1
  vlan-raw-device eth1
  up ip link set eth1.$2 mtu 1400"> /etc/network/interfaces.d/vlan

sudo modprobe 8021q
sudo systemctl restart networking