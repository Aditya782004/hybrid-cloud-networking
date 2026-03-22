# Tailscale Setup (Hybrid Connectivity)

## Overview

Tailscale is used to securely connect AWS EC2 and the local machine using an encrypted WireGuard-based tunnel.

The local machine advertises the VM subnet (`10.10.0.0/24`) so that EC2 can route traffic directly to virtual machines running on the local host.

In this architecture:

* AWS EC2 acts as the public entry point
* The local machine acts as a subnet router
* Linux kernel handles packet forwarding to VMs

---

## Step 1: Install Tailscale

Install Tailscale on:

* Local machine (laptop)
* AWS EC2 instance

```bash
curl -fsSL https://tailscale.com/install.sh | sh
```

---

## Step 2: Authenticate Both Machines

```bash
sudo tailscale up
```

Login using the same account on both systems.

---

## Step 3: Advertise VM Subnet (on local machine)

```bash
sudo tailscale up --advertise-routes=10.10.0.0/24
```

This tells Tailscale:

* This machine can route traffic to `10.10.0.0/24`
* It acts as a subnet router for the VM network

---

## Step 4: Approve Subnet Route (Tailscale Admin Console)

After advertising, the route must be approved manually.

* Go to Tailscale Admin Console
* Navigate to Machines
* Select your local machine
* Enable:
  `Subnet routes: 10.10.0.0/24`

---

## Step 5: Accept Route on EC2

On EC2, check route status:

```bash
tailscale status
```

You will see a message indicating that a peer is advertising a subnet.

Accept the route:

```bash
sudo tailscale up --accept-routes
```

---

## Step 6: Verify Connectivity

From EC2:

```bash
ping 10.10.0.10
```

If successful:

* EC2 can reach the VM inside the local network

---

## How Routing Works

Once the subnet route is accepted:

* EC2 learns that `10.10.0.0/24` is reachable via the local machine
* Traffic destined for `10.10.0.x` is sent through the Tailscale tunnel
* The local machine receives the packet and forwards it using Linux kernel routing

Forwarding is handled by:

* `net.ipv4.ip_forward=1`
* Kernel prefix-based routing
* Bridge interface (`br-vm`) delivering traffic to VMs

No reverse proxy is required on the local machine.

---

## Role in Architecture

* AWS EC2 runs NGINX and acts as a single entry point (TLS termination)
* Tailscale provides secure connectivity between EC2 and local machine
* Local machine routes traffic to VMs using kernel networking

---

## Result

* Secure communication between cloud and local infrastructure
* EC2 can directly access `10.10.0.0/24` network
* Traffic is routed efficiently without additional application-layer proxies
