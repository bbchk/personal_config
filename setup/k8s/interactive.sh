#!/bin/bash

# --- Change Password ---
read -p "Enter username: " USERNAME
read -sp "Enter new password for $USERNAME: " NEW_PASSWORD
echo
echo "$USERNAME:$NEW_PASSWORD" | chpasswd

# --- Change Hostname ---
read -p "Enter new hostname: " NEW_HOSTNAME
echo "$NEW_HOSTNAME" > /etc/hostname
sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts

# Update hostname immediately (works in Debian 13)
if command -v hostnamectl &> /dev/null; then
    hostnamectl set-hostname "$NEW_HOSTNAME"
else
    hostname "$NEW_HOSTNAME"
fi

read -p "Enter Tailscale auth key: " TS_AUTH_KEY
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey="$TS_AUTH_KEY" --accept-routes
