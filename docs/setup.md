# Full Setup Guide

## Steps Overview

1. Setup bridge networking
2. Configure DHCP (dnsmasq)
3. Enable NAT
4. Create VMs using KVM
5. Setup Tailscale connectivity
6. Configure NGINX on EC2

Follow individual modules under `networking/` and `kvm/` for detailed steps.

---

## Expected Result

* EC2 can access `10.10.0.0/24`
* VMs are reachable via Tailscale
* Traffic flows through EC2 → local → VM
