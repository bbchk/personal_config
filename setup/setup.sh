#!/usr/bin/env bash

set -euo pipefail

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

main() {
  show_menu
  read -rp "Enter your choice: " choice

  if ! validate_choice "$choice"; then
    main # Restart the script if invalid input
    return
  fi

  case "$choice" in
  1)
    echo "You selected Debian."
    ./debian/main.sh
    ;;
  2)
    echo "You selected Fedora."
    ./fedora/main.sh
    ;;
  3)
    echo "You selected Kubernetes."
    ./k8s/main.sh
    ;;
  *)
    echo "Wrong input, please try again."
    ;;
  esac
}

main
