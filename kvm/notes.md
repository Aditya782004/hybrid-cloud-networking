# Notes on VM Networking

* VMs are connected to `br-vm` (custom bridge)
* IPs are assigned via dnsmasq
* Default gateway is the bridge (10.10.0.1)
* Traffic flows via host for NAT and Tailscale routing

This setup enables:

* Full control over VM networking
* Integration with hybrid cloud architecture
