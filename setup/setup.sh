#!/usr/bin/env bash

# set -euo pipefail

# ====================================

# Function to display the setup options
show_menu() {
  echo "Please choose a setup. Enter a number:"
  echo "1. Debian"
  echo "2. Fedora"
  echo "3. Kubernetes"
}

validate_choice() {
  local choice="$1"
  if ! [[ "$choice" =~ ^[1-3]$ ]]; then
    echo "Invalid selection. Please choose a valid option between 1 and 3."
    return 1
  fi
  return 0
}

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
  show_menu

  sudo -v
  while true; do
    sudo -n true
    sleep 60
    kill -0 "$$" || exit
  done 2>/dev/null &

  read -rp "Enter your choice: " choice

  if ! validate_choice "$choice"; then
    main # Restart the script if invalid input
    return
  fi

  case "$choice" in
  1)
    echo "You selected Debian."
    "$HOME/pers/setup/debian/main.sh"
    ;;
  2)
    echo "You selected Fedora."
    "$HOME/pers/setup/fedora/main.sh" && "$HOME/pers/setup/common/gnome.sh" && "$HOME/pers/setup/common/filesystem.sh"
    ;;
  3)
    echo "You selected Kubernetes."
    "$HOME/pers/setup/k8s/main.sh"
    ;;
  *)
    echo "Wrong input, please try again."
    ;;
  esac
}

main
"$HOME/pers/setup/common/gnome.sh"
"$HOME/pers/setup/common/filesystem.sh"
"$HOME/pers/setup/teardown.sh"
