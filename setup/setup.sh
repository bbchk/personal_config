#!/usr/bin/env bash

validate_prerequisites() {
  if [ ! -f "$HOME/pers/password" ]; then
    echo "ERROR: $HOME/pers/password missing."

    touch password
    read -rp "Enter the password: " password_value
    echo "$password_value"
  fi
}

main() {
  validate_prerequisites
}

main
