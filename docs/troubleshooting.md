# Troubleshooting

## VM Not Getting IP

* Check dnsmasq:

```bash
systemctl status dnsmasq-br-vm
```

---

## No Internet in VM

* Check NAT rule:

```bash
iptables -t nat -L
```

---

## Cannot Reach VM from EC2

* Check Tailscale:

```bash
tailscale status
```

* Verify routing:

```bash
ip route get 10.10.0.10
```

---

## Bridge Issues

```bash
ip addr show br-vm
```

## Debug Traffic Flow

If connectivity is not working, verify packet flow using:

```bash id="td5"
tcpdump -i <interface>
```

Common interfaces:

* `tailscale0` → tunnel traffic
* `br-vm` → VM network
* `wlan0` / `eth0` → external traffic

This helps identify where packets are being dropped.
