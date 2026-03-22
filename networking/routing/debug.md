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

## Summary

If all checks pass:

* Tailscale is routing correctly
* Kernel is forwarding packets
* VMs are reachable from EC2
