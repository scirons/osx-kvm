#!/bin/bash

options="+kvm_pv_unhalt,+kvm_pv_eoi,+hypervisor,+invtsc,+pcid,+ssse3,+sse4.2,+popcnt,+avx,+aes,+fma,+fma4,+bmi1,+bmi2,+xsave,+xsaveopt,check"
sockets="1"
cores="2"
threads="4"
ram="4G"


qemu-system-x86_64 \
    -nodefaults \
    -enable-kvm  \
    -cpu Haswell-noTSX,kvm=on,vendor=GenuineIntel,+invtsc,+hypervisor,vmware-cpuid-freq=on,"$options" \
    -m "$ram" \
    -machine q35 \
    -smp "threads=$threads",cores="$cores",sockets="$sockets" \
    -usb -device usb-kbd -device usb-tablet  -device usb-mouse \
    -device usb-ehci,id=ehci \
    -device nec-usb-xhci,id=xhci \
    -global nec-usb-xhci.msi=off \
	  -device isa-applesmc,osk="ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc" \
	  -drive if=pflash,format=raw,readonly=on,file=./ovmf/OVMF_CODE.fd \
	  -drive if=pflash,format=raw,file=./ovmf/OVMF_VARS-1024x768.fd \
	  -smbios type=2 \
	  -device ich9-intel-hda -device hda-duplex \
    -device ich9-ahci,id=sata \
    -drive id=opencore,if=none,if=none,format=raw,aio=io_uring,detect-zeroes=on,file=OpenCore-v19.iso \
    -device ide-hd,bus=sata.1,drive=opencore,bootindex=1 \
    -drive file=/dev/sdc,format=raw,if=virtio \
	  -monitor stdio \
    -vga vmware \
    -netdev user,id=net0 -device virtio-net-pci,netdev=net0,id=net0,mac=52:54:00:c9:18:27 \
    $@
