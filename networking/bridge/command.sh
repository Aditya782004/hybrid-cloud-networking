# Run from: networking/bridge/

#!/bin/bash

set -e

echo "[1] Creating bridge interface..."
sudo ip link add br-vm type bridge || true
sudo ip link set br-vm up

echo "[2] Assigning IP to bridge..."
sudo ip addr add 10.10.0.1/24 dev br-vm || true

echo "[3] Enabling IP forwarding..."
sudo sysctl -w net.ipv4.ip_forward=1

echo "[4] Creating persistent bridge via NetworkManager..."
sudo nmcli connection add type bridge con-name br-vm ifname br-vm || true
sudo nmcli connection up br-vm

echo "[5] Copying dnsmasq config..."
sudo cp dnsmasq.conf /etc/dnsmasq.d/br-vm.conf

echo "[6] Installing dnsmasq service..."
sudo cp dnsmasq.service /etc/systemd/system/dnsmasq-br-vm.service

echo "[7] Reloading systemd..."
sudo systemctl daemon-reexec
sudo systemctl daemon-reload

echo "[8] Enabling and starting dnsmasq..."
sudo systemctl enable dnsmasq-br-vm
sudo systemctl start dnsmasq-br-vm

echo "[9] Verifying bridge..."
ip addr show br-vm

echo "Bridge setup complete."
