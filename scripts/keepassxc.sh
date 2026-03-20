#!/bin/bash

PASSWORD=$(secret-tool lookup application keepassxc)
DB_PATH="/home/bchk/pers/secrets/passwords/kbdx_passwords.kdbx"
KEY_PATH="/home/bchk/pers/secrets/passwords/kbdx_key"

echo "$PASSWORD" | keepassxc --pw-stdin --keyfile "$KEY_PATH" "$DB_PATH" > /dev/null 2>&1 & 

disown
