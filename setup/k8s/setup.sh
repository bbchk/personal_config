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
   -r -V 'DEBIAN_13_2_0_AMD64' \
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

txt.cfg

Here's a breakdown of the 4 parts of a preseed configuration entry:

```
d-i debian-installer/locale string en_US.UTF-8
```

## 1. **Owner** (`d-i`)
- Specifies which package/component "owns" this configuration question
- Common owners:
  - `d-i` = debian-installer (core installer)
  - `netcfg` = network configuration
  - `partman-auto` = automatic partitioning
  - `grub-installer` = GRUB bootloader
  - `tasksel` = task selection
  - `user-setup-udeb` = user setup

## 2. **Question/Template** (`debian-installer/locale`)
- The specific configuration question being answered
- Format: `component/question-name`
- This identifies what setting you're configuring
- Example: `debian-installer/locale` = the locale setting for the installer

## 3. **Data Type** (`string`)
- Defines what kind of value is expected
- Common types:
  - `string` = text value
  - `boolean` = true/false
  - `select` = choose one option from a list
  - `multiselect` = choose multiple options from a list
  - `password` = password value
  - `note` = informational (no value needed)
  - `error` = error message (no value needed)

## 4. **Value** (`en_US.UTF-8`)
- The actual answer/setting you want to apply
- Must match the expected data type
- Examples:
  - For `string`: any text like `en_US.UTF-8`, `debian-server`
  - For `boolean`: `true` or `false`
  - For `select`: one of the allowed choices

## More Examples:

```
netcfg         netcfg/get_hostname         string    myserver
├─owner        ├─question                  ├─type    ├─value


partman-auto   partman-auto/method         string    lvm
├─owner        ├─question                  ├─type    ├─value


clock-setup    clock-setup/utc             boolean   true
├─owner        ├─question                  ├─type    ├─value


tasksel        tasksel/first               multiselect   standard, ssh-server
├─owner        ├─question                  ├─type        ├─value
```

## Finding Valid Questions

To see all available questions for a component:
```bash
debconf-get-selections | grep component-name
```

Or during installation with debug enabled:
```bash
debconf-get-selections --installer
```



d-i netcfg/choose_interface select auto-ethernet                   # Try Ethernet first
d-i netcfg/dhcp_timeout string 15                                  # Wait 15 seconds for network
d-i netcfg/dhcp_failed note                                        # Continue on failure
d-i netcfg/dhcp_options select Retry network autoconfiguration with a DHCP hostname  # Retry once


# d-i preseed/late_command string \
#     cp /cdrom/scripts/network-config/interfaces /target/etc/network/interfaces; \
#     cp /cdrom/scripts/network-config/resolv.conf /target/etc/resolv.conf
