#!/usr/bin/env bash

set -euo pipefail

# Update system and install essentials
sudo apt update
sudo apt upgrade -y

# Debian package equivalents (where available)
PKGS=(
  netcat-openbsd
  maven
  dnsutils
  openjdk-17-jdk
  sioyek
  tree
  git
  keepassxc
  tmux
  neovim
  openfortivpn
  fzf
  gh
  zsh
  brightnessctl
  pavucontrol
  blueman
  stow
  android-tools-adb
  nautilus
  qbittorrent
  mpv
  golang
  lua5.4
  acpi
  keychain
  man
  zip
  unzip
  lsof
  fonts-firacode
  fonts-font-awesome
  bluez
  bluez-tools
  firmware-sof-signed
  postgresql
  ppp
  manpages
  shellcheck
  net-tools
  default-jre
  docker.io
  desktop-base
  curl
  fd-find
  ripgrep
  fzf
)


# Install available Debian packages
echo "Installing packages..."
sudo apt install -y "${PKGS[@]}"


echo
echo "Debian Bookworm package installation script complete."
echo "Manual steps may be needed for packages not directly available or with no clear alternative (hyprpaper, mako, hypridle, xwaylandvideobridge-git, grim, grimshot)."
echo "Consider: Flatpak, Snap, or compiling from source for these."
