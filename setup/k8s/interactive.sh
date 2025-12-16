#!/bin/bash

# --- Change Password ---
read -p "Enter username: " USERNAME
read -p "Enter new password for $USERNAME: " NEW_PASSWORD
echo
echo "$USERNAME:$NEW_PASSWORD" | /usr/sbin/chpasswd

# --- Change Hostname ---
read -p "Enter new hostname: " NEW_HOSTNAME
hostnamectl set-hostname "$NEW_HOSTNAME"
sed -i "s/127.0.1.1.*/127.0.1.1\t$NEW_HOSTNAME/" /etc/hosts

# --- Set up Tailscale ---
read -p "Enter Tailscale auth key: " TS_AUTH_KEY
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey="$TS_AUTH_KEY" --accept-routes
