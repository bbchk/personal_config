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
#
#
#
on late-command change password, change hostname


That is a crucial question that gets to the heart of how static addressing works in a home or office network!

When you manually assign an IP address (a **Static IP**) on your machine (like you're doing with the Debian preseed file), you do **not** need to "tell" the router anything. The router is designed to route traffic based on the IP address, regardless of how that address was assigned.

However, to ensure your machine's static IP address works reliably and doesn't cause problems for other devices, you need to manage the **router's DHCP server** settings.

## 🔑 Two Ways to Handle Static IP Addresses

You have two main strategies for using a static IP, and the best one depends on your preference for central management:

### 1. The Simplest Way: Keep the Static IP **Outside** the DHCP Range (Recommended)

The goal here is to make sure your router's automatic IP assignment (DHCP) never accidentally tries to assign your chosen static IP address to another device.

1.  **Check the Router's DHCP Range:** Log into your router's web interface (usually by entering the **Gateway IP** into a web browser, e.g., `http://192.168.1.1`).
2.  **Find the DHCP Settings:** Look for sections labeled **LAN Settings**, **DHCP Server**, or **Address Pool**.
    * Typically, the router's default DHCP range is something like `192.168.1.100` to `192.168.1.254`.
3.  **Choose an IP Outside the Range:**
    * If the range starts at `100`, choose a static IP below it, like **`192.168.1.10`** or **`192.168.1.50`**.
    * *Example:* If your router's DHCP pool is `192.168.1.100` to `254`, set your Debian machine to `192.168.1.20`.
4.  **Action on Router:** You don't have to do anything else. The router will respect your static IP and won't assign that specific address to other devices because it's outside its automated pool. 

### 2. The Centralized Way: DHCP Reservation (Recommended for Laptops/Mobile Devices)

DHCP Reservation is when you tell the **router** to manage the static assignment. The device itself is still configured to use DHCP (automatic IP), but the router is configured to *always* give the same IP to that device based on its **MAC address**.

This method is generally more flexible, as you manage all your static assignments in one central place (the router).

1.  **Find the Machine's MAC Address:** You need the unique Media Access Control (MAC) address of the network card you are using for the Debian install (e.g., `00:1A:2B:3C:4D:5E`).
    * *Note:* You'll need to install the OS first and then check the address using a command like `ip a` or `ip link` on the Debian machine.
2.  **Access Router Settings:** Log into your router's web interface.
3.  **Create a Reservation:** Navigate to **DHCP Settings** or **Address Reservation**.
4.  **Bind the IP and MAC:** Create a new entry that **binds** the machine's **MAC address** to the desired **Static IP address** (e.g., bind `00:1A:2B:3C:4D:5E` to `192.168.1.100`).

**Crucially, if you use this method, you must remove the static IP configuration from your preseed file and switch back to DHCP (the default for the installer) on the machine itself.**

Since you are already setting a static IP in the preseed file, **Strategy 1** (keeping the static IP outside the DHCP pool) is the path of least resistance and requires no further action on the router besides verifying the pool range.

---

This video provides an overview of how to set static IP addresses and DHCP reservations on a device using a router's settings.

[Set a Static IP Address for a Device | DHCP IP Reservation](https://www.youtube.com/watch?v=-G3ePnXAoHc)


http://googleusercontent.com/youtube_content/0
