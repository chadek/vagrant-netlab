#!/bin/bash

echo "8021q"> /etc/modules
echo "
auto eth1.100                                              
iface eth1.100 inet6 static
  address fd00:100::1/64            
  vlan-raw-device eth1 
  up ip link set eth1.100 mtu 1400

auto eth1.200                                              
iface eth1.200 inet6 static
  address fd00:200::1/64            
  vlan-raw-device eth1
  up ip link set eth1.200 mtu 1400"> /etc/network/interfaces.d/vlan


echo "
net.ipv4.conf.all.forwarding=1
net.ipv6.conf.default.forwarding=1
net.ipv6.conf.all.forwarding=1
net.ipv6.conf.default.proxy_ndp=1
net.ipv6.conf.all.proxy_ndp=1

net.ipv4.ip_nonlocal_bind=1
net.ipv6.ip_nonlocal_bind=1"> /etc/sysctl.conf


sudo modprobe 8021q
sudo systemctl restart networking
sudo sysctl -p
sudo apt update
sudo apt install -y frr

sudo sed -i 's/ospf6d=.*/ospf6d=true/g' /etc/frr/daemons

sudo systemctl restart frr