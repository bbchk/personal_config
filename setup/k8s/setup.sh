#!/usr/bin/env bash

su

apt update
apt install sudo vim

update-alternatives --config editor

# visudo thing

systemctl mask  "dev-*.swap"



# HandlePowerKey=poweroff        # Can be poweroff, reboot, halt, ignore
# HandleLidSwitch=suspend        # Can be suspend, ignore, lock, etc.
# HandleLidSwitchDocked=ignore   # Controls lid action when docked
# IdleAction=ignore              # Can be suspend, poweroff, etc.
# IdleActionSec=30min            # Time before IdleAction triggers

systemctl restart systemd-logind

wifi_device=$(basename $(echo /sys/class/net/wlp*))
ip link set "${wifi_device}" down


# /etc/network/interfaces
# auto enp3s0
# iface enp3s0 inet static
#     address 192.168.1.10
#     netmask 255.255.255.0
#     gateway 192.168.1.1
#     metric 100
#
#



sudo nano /etc/systemd/network/10-static-eth0.network

[Match]
Name=eth0  # Replace 'eth0' with your actual interface name (e.g., enp1s0)

[Network]
Address=192.168.1.100/24  # Static IP and CIDR netmask
Gateway=192.168.1.1       # Router IP
DNS=8.8.8.8               # Primary DNS server
#DNS=8.8.4.4              # Optional secondary DNS server
#Domains=localdomain      # Optional local domain name

sudo systemctl enable systemd-networkd
sudo systemctl restart systemd-networkd

orig_iso="$HOME"/downloads/debian-13.2.0-amd64-netinst.iso
new_files="$HOME"/pers/setup/k8s/iso
new_iso="$HOME"/pers/bchk-baked-debian-13.2.0-amd64-netinst.iso
mbr_template=isohdpfx.bin

dd if="$orig_iso" bs=1 count=432 of="$mbr_template"

xorriso -as mkisofs \
   -r -V 'Debian 13.2.0 amd64 n' \
   -o "$new_iso" \
   -J -J -joliet-long -cache-inodes \
   -isohybrid-mbr "$mbr_template" \
   -b isolinux/isolinux.bin \
   -c isolinux/boot.cat \
   -boot-load-size 4 -boot-info-table -no-emul-boot \
   -eltorito-alt-boot \
   -e boot/grub/efi.img \
   -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus \
   "$new_files"

https://wiki.debian.org/ManipulatingISOs#Remaster_an_Installation_Image
https://wiki.debian.org/RepackBootableISO

https://wiki.debian.org/DebianInstaller/Preseed/EditIso
