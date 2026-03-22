#!/bin/bash

set -e

#Change The interface name And Subnet according to your Setup.
INTERFACE="wlan0"
SUBNET="10.10.0.0/24"

echo "[1] Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

echo "[2] Applying NAT rule..."
sudo iptables -t nat -A POSTROUTING -s $SUBNET -o $INTERFACE -j MASQUERADE

echo "[3] Verifying rules..."
sudo iptables -t nat -L -v -n

echo "NAT setup complete."
