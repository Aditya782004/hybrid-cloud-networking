# Attaching Additional Disk to VM

## Step 1: Create Disk

```bash
qemu-img create -f qcow2 /var/lib/libvirt/images/vm-extra.qcow2 30G
```

---

## Step 2: Attach Disk to VM

```bash
virsh attach-disk vm-name \
  /var/lib/libvirt/images/vm-extra.qcow2 \
  vdb \
  --persistent \
  --driver qemu \
  --subdriver qcow2 \
  --targetbus virtio
```

---

## Explanation

* `vm-name` → target VM
* `vdb` → device name inside VM
* `--persistent` → survives reboot
* `virtio` → high-performance disk interface

---

## Result

* VM gets additional storage
* Disk persists across reboots
