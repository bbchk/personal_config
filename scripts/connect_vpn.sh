#!/usr/bin/env bash

source "$HOME/pers/scripts/utils"

region=${1:-"west1"}

log "Killing existing openfortivpn processes..."
pkill -9 openfortivpn 2>/dev/null
sleep 1

SECRET_FILE="$HOME/pers/secrets/ib/carsdirect_totp_secret_key"
TIME_STEP=60
DIGITS=6
SECRET=$(tr -d '[:space:]' < "$SECRET_FILE")
TOTP=$(oathtool --totp -b --time-step-size=${TIME_STEP}s --digits=${DIGITS} "$SECRET")
log "Generated TOTP for VPN authentication"

config_file="$HOME/pers/secrets/ib/carsdirect_credentials.cfg"
host="vpn-${region}.internetbrands.com:443"

log "Connecting to $host..."
sudo openfortivpn "$host" -c "${config_file}" -o "${TOTP}" &
disown
log "VPN connection initiated in background"
