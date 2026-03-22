# NAT Configuration (Outbound Internet Access for VMs)

## Overview

This setup enables virtual machines in the `10.10.0.0/24` network to access the internet by performing Network Address Translation (NAT) on the host system.

---

## NAT Rule

```bash
iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o wlan0 -j MASQUERADE
```

---

## Explanation

* `-t nat` → Use NAT table
* `POSTROUTING` → Apply after routing decision
* `-s 10.10.0.0/24` → Source network (VM subnet)
* `-o wlan0` → Outgoing interface (change based on your system)
* `MASQUERADE` → Rewrites source IP to host’s IP

---

## Important

Replace `wlan0` with your actual outbound interface:

```bash
ip route get 8.8.8.8
```

This shows which interface is used for internet traffic.

---

## TO check If the POSTROUTING Rule is Added To the iptable.

sudo iptables -t nat -L  -v -n


## Result

* VMs can access external networks
* Responses are correctly routed back
* Internal IPs remain private
