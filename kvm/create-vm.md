# VM Creation using KVM (virt-install)

## Overview

Virtual machines are created using `virt-install` and attached to the custom bridge (`br-vm`) instead of the default libvirt network.

---

## Command

```bash
sudo virt-install \
  --name vm-example \
  --memory 2048 \
  --vcpus 2 \
  --cpu host-passthrough \
  --machine q35 \
  --disk path=/var/lib/libvirt/images/vm-example.qcow2,format=qcow2,bus=virtio,size=25 \
  --cdrom /var/lib/libvirt/images/ubuntu-22.04.iso \
  --os-variant ubuntu22.04 \
  --network bridge=br-vm,model=virtio \
  --boot uefi \
  --graphics spice \
  --console pty,target_type=serial \
  --noautoconsole
```

---

## Important Parameters

* `--name` → VM name
* `--memory`, `--vcpus` → resource allocation
* `--disk` → storage location and size
* `--cdrom` → OS ISO path
* `--network bridge=br-vm` → attach VM to custom bridge
* `--cpu host-passthrough` → better performance

---

## Key Design Choice

Using `bridge=br-vm` instead of default NAT network allows:

* Direct IP assignment via dnsmasq
* Full control over networking
* Integration with hybrid cloud routing
