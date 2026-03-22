#!/bin/bash

# Example VM creation

virt-install \
  --name vm-example \
  --memory 2048 \
  --vcpus 2 \
  --disk path=/var/lib/libvirt/images/vm-example.qcow2,size=25 \
  --cdrom /var/lib/libvirt/images/ubuntu.iso \
  --network bridge=br-vm \
  --os-variant ubuntu22.04

# Example disk creation

qemu-img create -f qcow2 /var/lib/libvirt/images/vm-extra.qcow2 30G
