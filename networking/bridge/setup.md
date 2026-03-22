# Linux Bridge Setup for VM Networking

## Overview

This setup creates a custom Linux bridge (`br-vm`) to allow communication between the host machine and KVM virtual machines.

It ensures:

* VM-to-VM communication
* Host-to-VM communication
* External traffic forwarding

---

## Step 1: Create a Bridge Interface

```bash
ip link add sample type bridge
```

This creates a Linux bridge device.

---

## Step 2: Enable IP Forwarding

```bash
sysctl -w net.ipv4.ip_forward=1
```

This ensures the Linux kernel forwards packets instead of dropping them.

---

## Step 3: Create Persistent Bridge using NetworkManager

```bash
sudo nmcli connection add type bridge con-name br-vm ifname br-vm
```

This ensures:

* Bridge is recreated automatically on reboot
* Managed properly by NetworkManager

---

## Step 4: DHCP Setup using dnsmasq

### systemd Service File

`networking/bridge/dnsmasq.service`

```ini
[Unit]
Description=dnsmasq DHCP for br-vm
After=network-online.target
Wants=network-online.target

[Service]
ExecStart=/usr/bin/dnsmasq \
  --no-daemon \
  --conf-file=/etc/dnsmasq.d/br-vm.conf \
  --user=dnsmasq

Restart=on-failure

[Install]
WantedBy=multi-user.target
```

---

### dnsmasq Configuration

`networking/bridge/dnsmasq.conf`

```ini
interface=br-vm
bind-interfaces
port=0

dhcp-range=10.10.0.50,10.10.0.200,255.255.255.0,24h
dhcp-option=3,10.10.0.1
dhcp-leasefile=/var/lib/dnsmasq/br-vm.leases
dhcp-authoritative
```

### Notes

* `dhcp-leasefile` ensures persistent IP allocation
* Gateway is set to `10.10.0.1` (bridge IP)

---

## Step 5: Create Virtual Machines

```bash
sudo virt-install \
  --name vm-example \
  --memory 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --machine q35 \
  --disk path=/var/lib/libvirt/images/vm-example.qcow2,format=qcow2,bus=virtio,size=25 \
  --cdrom /var/lib/libvirt/images/ubuntu-22.04.iso \
  --os-variant ubuntu22.04 \
  --network bridge=br-vm,model=virtio \
  --boot uefi \
  --graphics spice \
  --console pty,target_type=serial \
  --noautoconsole
```

### Important Parameters

* `--name` → VM name
* `--memory`, `--vcpus` → resources
* `--disk` → storage path and size
* `--network bridge=br-vm` → attach to custom bridge

---

## Step 6: Add Additional Storage

### Create Disk

```bash
qemu-img create -f qcow2 /var/lib/libvirt/images/vm-extra.qcow2 30G
```

### Attach Disk

```bash
virsh attach-disk vm-name \
  /var/lib/libvirt/images/vm-extra.qcow2 \
  vdb \
  --persistent \
  --driver qemu \
  --subdriver qcow2 \
  --targetbus virtio
```

---

## Troubleshooting

### Check Routing Path

```bash
ip route get 8.8.8.8
```

### Check Internal Routing

```bash
ip route get 10.10.0.10
```

### Show Routing Table

```bash
ip route show table 52
```

---

This setup enables:

* Persistent Linux bridge networking
* DHCP-based VM IP allocation
* Host ↔ VM communication
* Foundation for hybrid cloud connectivity
