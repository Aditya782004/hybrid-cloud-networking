# Hybrid Cloud-to-Local Virtualized Network Architecture

IMPORTANT NOTICE:-
(This Repo Assumes That You have Already Setup KVM,Qemu,Libvirt)

## Architecture Diagram

![Architecture Diagram](architecture/architecture-diagram.svg)

---

## Overview

This project demonstrates a hybrid cloud architecture where an AWS-hosted service securely communicates with locally hosted virtual machines.

It simulates a real-world scenario where cloud infrastructure must integrate with on-premise systems using encrypted networking and controlled traffic routing.

---

## Problem Statement

Modern systems often require communication between cloud and local environments. Achieving this securely while maintaining control over networking, routing, and access is complex.

---

## Solution

This project implements a hybrid networking model using:

* AWS EC2 as a public entry point
* Tailscale (WireGuard) for encrypted connectivity
* Local KVM virtual machines
* Linux bridge networking for VM communication
* NGINX reverse proxy for request routing
* dnsmasq for DHCP and DNS
* iptables for NAT and internet access

---

## Packet Flow

1. User sends request to domain (example.com)
2. DNS resolves to AWS EC2 public IP
3. Request enters AWS via Internet Gateway
4. Security Group allows inbound traffic
5. EC2 forwards traffic through Tailscale tunnel
6. Encrypted traffic reaches local host
7. Linux bridge routes packet to VM
8. NGINX forwards request to service
9. Response returns through the same path

---

## Key Concepts

**Hybrid Cloud Networking**

* Connecting cloud infrastructure with local systems
* Secure communication across environments

**Linux Networking**

* Layer 2 bridging and ARP
* Layer 3 routing and CIDR matching
* NAT using iptables

**Virtualization**

* KVM and Libvirt for VM management
* Persistent bridge-based networking

**Secure Networking**

* WireGuard-based encrypted tunnels via Tailscale

---

## Tech Stack

* AWS (EC2, VPC)
* Tailscale (WireGuard)
* KVM, Libvirt
* Linux networking (bridge, routing, NAT)
* NGINX
* dnsmasq

---

## Features

* Secure hybrid cloud architecture
* Encrypted communication between environments
* Scalable VM networking
* NAT-based internet access for VMs
* Reverse proxy routing

---

## Project Structure

```
hybrid-cloud-networking/
├── architecture/
├── kvm/
├── nginx/
├── dns/
└── docs/
```

---

## What I Learned

* Designing hybrid cloud systems
* Linux networking internals
* Virtualization networking
* Secure communication across networks
* Debugging multi-layer network flows

---

Author

Aditya Vaghasiya
DevOps Engineer
Ahmedabad, India

#If you found this useful

Give it a star ⭐ and feel free to connect!
