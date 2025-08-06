#!/usr/bin/env bash

set -euo pipefail

# gem install rails

# Update system and install essentials
sudo apt update
sudo apt upgrade -y

 # ╰$ sudo apt-get install libmariadb-dev

# TODO: include
# sudo apt install -y \
#   build-essential \
#   libssl-dev \
#   libreadline-dev \
#   zlib1g-dev \
#   libyaml-dev \
#   libffi-dev \
#   libgdbm-dev \
#   libncurses5-dev \
#   libgdbm6 \
#   libdb-dev \
#   uuid-dev
#
# #sudo apt install -y \
#   libssh2-1-dev \
#   libgit2-dev \
#   cmake \
#   pkg-config
# #   sudo apt install -y \
#   build-essential \
#   libssh2-1-dev \
#   libgit2-dev \
#   libssl-dev \
#   zlib1g-dev \
#   cmake \
#   pkg-config
#
# Debian package equivalents (where available)
PKGS=(
  kubectx
  python3-venv
  libyaml-dev
  rbenv
  ruby-dev
  luarocks
  traceroute
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
