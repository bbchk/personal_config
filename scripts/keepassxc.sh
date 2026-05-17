#!/bin/bash

source "$HOME/pers/scripts/utils.sh"

log "Retrieving KeePassXC password from keyring..."
PASSWORD=$(secret-tool lookup application keepassxc)
DB_PATH="/home/bchk/pers/secrets/my/keepassxc/kbdx_passwords.kdbx"
KEY_PATH="/home/bchk/pers/secrets/my/keepassxc/kbdx_key"

log "Launching KeePassXC with database: $DB_PATH"
echo "$PASSWORD" | keepassxc --pw-stdin --keyfile "$KEY_PATH" "$DB_PATH" > /dev/null 2>&1 & 

disown
log "KeePassXC started in background"
