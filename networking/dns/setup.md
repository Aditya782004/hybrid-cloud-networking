# DHCP Setup using dnsmasq

## Overview

dnsmasq is used to provide DHCP services for VMs connected to the `br-vm` bridge.

It assigns IP addresses dynamically and maintains persistent leases.

---

## Configuration File

`dnsmasq.conf`

```ini id="d1"
interface=br-vm
bind-interfaces
port=0

dhcp-range=10.10.0.50,10.10.0.200,255.255.255.0,24h
dhcp-option=3,10.10.0.1
dhcp-leasefile=/var/lib/dnsmasq/br-vm.leases
dhcp-authoritative
```

---

## Key Points

* Runs only on `br-vm`
* Assigns IPs to VMs
* Gateway is `10.10.0.1`
* Lease file ensures persistence

---

## Start Service

```bash id="d2"
systemctl daemon-reload
systemctl enable dnsmasq-br-vm
systemctl start dnsmasq-br-vm
```

---

## Verification

```bash id="d3"
cat /var/lib/dnsmasq/br-vm.leases
```

---

## Result

* VMs receive IP automatically
* Persistent IP mapping across reboots
