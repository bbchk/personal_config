#!/bin/bash

set -e

read -p "Enter username: " USERNAME
echo -n "Enter new password for $USERNAME: "

stty -echo
read NEW_PASSWORD
stty echo

echo

echo "$USERNAME:$NEW_PASSWORD" | sudo /usr/sbin/chpasswd

# --- Change Hostname ---
read -p "Enter new hostname: " NEW_HOSTNAME
sudo hostnamectl set-hostname "$NEW_HOSTNAME"
sudo sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts
sudo systemctl restart networking || sudo systemctl restart NetworkManager

# --- Tailscale ---
read -p "Enter Tailscale auth key: " TS_AUTH_KEY
curl -fsSL https://tailscale.com/install.sh | sudo sh
sudo tailscale up --authkey="$TS_AUTH_KEY" --accept-routes
