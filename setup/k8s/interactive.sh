#!/bin/bash

# --- Change Password ---
read -sp "Enter new password for user: " NEW_PASSWORD
echo "$USER:$NEW_PASSWORD" | chpasswd

# --- Change Hostname ---
read -p "Enter new hostname: " NEW_HOSTNAME
echo "$NEW_HOSTNAME" > /etc/hostname
hostnamectl set-hostname "$NEW_HOSTNAME"
sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts

# --- Install Tailscale ---
read -p "Enter Tailscale auth key: " TS_AUTH_KEY
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey="$TS_AUTH_KEY"

/usr/bin/clear
