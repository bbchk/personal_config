#!/bin/bash

/usr/bin/apt-get update
/usr/bin/apt-get install -y sudo vim net-tools openssh-server ifupdown

update-alternatives --set editor /usr/bin/vim.basic

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

/usr/bin/clear
