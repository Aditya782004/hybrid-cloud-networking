# Routing Debugging (Tailscale + VM Network)

## Verify Tailscale Interface

```bash id="rd1"
ip addr show tailscale0
```

Ensure interface exists and has an IP.

---

## Check Routing Rules

```bash id="rd2"
ip rule show
```

Look for:

```text id="rd3"
lookup 52
```

This confirms Tailscale policy routing is active.

---

## Check Routing Table 52

```bash id="rd4"
ip route show table 52
```

Expected output:

```text id="rd5"
100.x.x.x dev tailscale0
```

This confirms Tailscale routes are installed.

---

## Verify Route Selection

```bash id="rd6"
ip route get 10.10.0.10
```

This shows how traffic will be routed.

---

## Check Forwarding

```bash id="rd7"
sysctl net.ipv4.ip_forward
```

Expected:

```text id="rd8"
net.ipv4.ip_forward = 1
```

---

## Test Connectivity from EC2

```bash id="rd9"
ping 10.10.0.10
```

---

## Common Issues

### 1. Route Not Accepted

* Run:

```bash id="rd10"
tailscale status
```

* Accept route using:

```bash id="rd11"
sudo tailscale up --accept-routes
```

---

### 2. No Traffic Forwarding

* Ensure IP forwarding is enabled
* Check NAT rules

---

### 3. Bridge Not Working

* Verify:

```bash id="rd12"
ip addr show br-vm
```

---

## Packet-Level Debugging (tcpdump)

To verify whether traffic is actually reaching the system, use `tcpdump`.

---

### Check Traffic on Tailscale Interface

```bash id="td1"
tcpdump -i tailscale0
```

This shows:

* Incoming traffic from EC2
* Encrypted tunnel packets

---

### Check Traffic on Bridge Interface

```bash id="td2"
tcpdump -i br-vm
```

This verifies:

* Whether packets are being forwarded to VMs

---

### Check Traffic on External Interface

```bash id="td3"
tcpdump -i wlan0
```

This helps confirm:

* NAT is working
* Outbound traffic is leaving the host

---

### Filter by IP (optional)

```bash id="td4"
tcpdump -i tailscale0 host 10.10.0.10
```

---

## How to Use This

* If traffic appears on `tailscale0` but not on `br-vm` → routing issue
* If traffic appears on `br-vm` but VM doesn’t respond → VM issue
* If no traffic on `tailscale0` → Tailscale or EC2 issue

---

## Summary

`tcpdump` allows you to trace packets across:

* Tailscale tunnel
* Host routing layer
* Bridge interface

This is essential for debugging multi-layer network flows.

---

## Neighbor Table (MAC Resolution)

To verify MAC address resolution for VMs:

```bash
ip neigh
```

Example output:

```text
10.10.0.10 dev br-vm lladdr aa:bb:cc:dd:ee:ff REACHABLE
```

---

## What This Means

* `10.10.0.10` → VM IP
* `lladdr` → MAC address of VM
* `br-vm` → interface used
* `REACHABLE` → ARP resolution successful

---

## Why MAC Address is Required

Even though routing uses IP addresses (Layer 3), actual packet transmission happens using MAC addresses (Layer 2).

Flow:

1. Kernel checks routing table (IP level)
2. Determines outgoing interface
3. Resolves destination MAC using ARP
4. Sends Ethernet frame to that MAC

Without MAC resolution:

* Packet cannot be physically transmitted
* Communication fails even if routing is correct

---

## Debugging Strategy

Use together:

* `ip route` → where packet should go
* `ip neigh` → who owns the IP (MAC)
* `tcpdump` → is packet actually flowing

---

## Quick Diagnosis

* No `ip neigh` entry → ARP not happening
* `FAILED` state → VM unreachable
* Correct MAC present → L2 working

---


## Summary

If all checks pass:

* Tailscale is routing correctly
* Kernel is forwarding packets
* VMs are reachable from EC2
