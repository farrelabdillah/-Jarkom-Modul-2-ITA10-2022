#!/bin/env bash

if [[ $(hostname) = "Ostania" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.214.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.214.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.214.3.1
	netmask 255.255.255.0
EOS

	iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.214.0.0/16
    
elif [[ $(hostname) = "SSS" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.214.1.2
	netmask 255.255.255.0
	gateway 192.214.1.1
EOS

	cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

elif [[ $(hostname) = "Garden" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.214.1.3
	netmask 255.255.255.0
	gateway 192.214.1.1
EOS

	cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

elif [[ $(hostname) = "WISE" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.214.2.2
	netmask 255.255.255.0
	gateway 192.214.2.1
EOS

	cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

elif [[ $(hostname) = "Berlint" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.214.3.2
	netmask 255.255.255.0
	gateway 192.214.3.1
EOS

	cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

elif [[ $(hostname) = "Eden" ]]; then
	cat << EOS > /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.214.3.3
	netmask 255.255.255.0
	gateway 192.214.3.1
EOS

	cat << EOS > /etc/resolv.conf
nameserver 192.168.122.1
EOS

fi