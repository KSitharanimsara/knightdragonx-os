#!/bin/bash
set -e

# Stop services
/usr/bin/pkill -9 hostapd || true
/usr/bin/pkill -9 dnsmasq || true

# Remove NAT rules
/usr/sbin/iptables -t nat -D POSTROUTING -o wlo1 -j MASQUERADE || true
/usr/sbin/iptables -D FORWARD -i wlo1 -o wlo1_ap -m state --state RELATED,ESTABLISHED -j ACCEPT || true
/usr/sbin/iptables -D FORWARD -i wlo1_ap -o wlo1 -j ACCEPT || true

# Bring down and delete AP interface
/usr/sbin/ip link set wlo1_ap down 2>/dev/null || true
/usr/sbin/iw dev wlo1_ap del 2>/dev/null || true
