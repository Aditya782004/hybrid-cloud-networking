# Routing Behavior (Tailscale + Linux Kernel)

## Overview

After subnet advertisement via Tailscale, routing is handled entirely by the Linux kernel using policy routing and prefix matching.

No additional application-layer routing is required.

---

## IP Rules

Check routing rules:

```bash id="rs1"
ip rule show
```

Example:

```text id="rs2"
5270: from all lookup 52
```

This rule tells the kernel:

* Use routing table `52` for certain traffic
* This table is managed by Tailscale

---

## Routing Table 52

Check routes:

```bash id="rs3"
ip route show table 52
```

Example:

```text id="rs4"
100.x.x.x dev tailscale0
```

---

## What This Means

* `tailscale0` is the interface used for encrypted communication
* Traffic matching Tailscale peers is routed via this interface
* When EC2 sends traffic to `10.10.0.0/24`, it is forwarded through this path

---

## Packet Flow Inside Local Machine

1. Packet arrives via `tailscale0`
2. Kernel checks routing rules (`ip rule`)
3. Matching rule sends lookup to table 52
4. Kernel determines next hop via `tailscale0`
5. Packet is forwarded to `br-vm`
6. Bridge delivers packet to VM

---

## Key Point

Routing is handled by:

* Policy routing (`ip rule`)
* Routing tables (`ip route`)
* Kernel forwarding (`ip_forward=1`)

No reverse proxy or user-space routing is involved.
