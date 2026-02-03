#!/bin/bash

/usr/bin/apt-get update
/usr/bin/apt-get install -y sudo vim net-tools openssh-server ifupdown curl wget

update-alternatives --set editor /usr/bin/vim.basic

# The industry standard is to avoid editing the main /etc/sudoers file directly. Instead, you should drop a configuration file into the /etc/sudoers.d/ directory. It’s cleaner, modular, and much harder to break.
echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/nopasswd_sudo

gpasswd -a bchk sudo

# ---------

SSH_CONFIG="/etc/ssh/sshd_config"

sed -i 's/GSSAPIAuthentication yes/GSSAPIAuthentication no/' "$SSH_CONFIG"
sed -i 's/KerberosAuthentication yes/KerberosAuthentication no/' "$SSH_CONFIG"

systemctl restart sshd

# ---------

logind_conf="/etc/systemd/logind.conf"
sed -i 's/#HandlePowerKey=poweroff/HandlePowerKey=ignore/' "$logind_conf"
sed -i 's/#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' "$logind_conf"
sed -i 's/#HandleLidSwitchExternalPower=suspend/HandleLidSwitch=ignore/' "$logind_conf"
sed -i 's/#HandleLidSwitchDocked=ignore/HandleLidSwitchDocked=ignore/' "$logind_conf"
sed -i 's/#IdleAction=suspend/IdleAction=ignore/' "$logind_conf"

systemctl restart systemd-logind

# --- Disable Swap Memory ---
swapoff -a

/usr/bin/clear
