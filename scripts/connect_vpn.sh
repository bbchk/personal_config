#!/usr/bin/env bash

region=${1:-"west1"}

pkill -9 openfortivpn 2>/dev/null
sleep 1

SECRET_FILE="$HOME/pers/secrets/vpn/totp_secret_key"
TIME_STEP=60
DIGITS=6
SECRET=$(tr -d '[:space:]' < "$SECRET_FILE")
TOTP=$(oathtool --totp -b --time-step-size=${TIME_STEP}s --digits=${DIGITS} "$SECRET")

config_file="$HOME/pers/secrets/vpn/credentials.cfg"
host="vpn-${region}.internetbrands.com:443"

sudo openfortivpn "$host" -c "${config_file}" -o "${TOTP}" &
disown
