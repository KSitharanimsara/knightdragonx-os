#!/bin/bash
set -e

# Clean up any existing AP interface
/usr/sbin/iw dev wlo1_ap del 2>/dev/null || true
sleep 1

# Create AP interface
/usr/bin/iw phy phy0 interface add wlo1_ap type __ap
sleep 1

# Configure AP interface
/usr/bin/ip link set dev wlo1_ap address 02:00:00:00:00:01
/usr/bin/ip link set wlo1_ap up
/usr/bin/ip addr add 192.168.10.1/24 dev wlo1_ap

# Start hostapd as daemon
/usr/sbin/hostapd -B /etc/hostapd/hostapd-wlo1.conf
sleep 2

# Start dnsmasq
/usr/sbin/dnsmasq -C /etc/dnsmasq.conf --conf-dir=/etc/dnsmasq.d

# Set up NAT
/usr/sbin/iptables -t nat -A POSTROUTING -o wlo1 -j MASQUERADE
/usr/sbin/iptables -A FORWARD -i wlo1 -o wlo1_ap -m state --state RELATED,ESTABLISHED -j ACCEPT
/usr/sbin/iptables -A FORWARD -i wlo1_ap -o wlo1 -j ACCEPT
