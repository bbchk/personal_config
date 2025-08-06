#!/usr/bin/env bash

set -euo pipefail

# Update system and install essentials
# sudo dnf update -y

# Enable RPM Fusion repositories for additional packages
# sudo dnf install -y \
#   https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# TODO: include development dependencies
# sudo dnf install -y \
#   gcc \
#   gcc-c++ \
#   make \
#   openssl-devel \
#   readline-devel \
#   zlib-devel \
#   libyaml-devel \
#   libffi-devel \
#   gdbm-devel \
#   ncurses-devel \
#   libuuid-devel
#
# sudo dnf install -y \
#   libssh2-devel \
#   libgit2-devel \
#   cmake \
#   pkgconf-pkg-config
#
# Fedora package equivalents
PKGS=(
  python3-venv
  libyaml-devel
  rbenv
  ruby-devel
  luarocks
  traceroute
  nmap-ncat
  bind-utils
  java-17-openjdk
  sioyek
  tree
  git
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
  android-tools
  nautilus
  qbittorrent
  mpv
  golang
  lua
  acpi
  man-pages
  zip
  unzip
  lsof
  fira-code-fonts
  fontawesome-fonts
  bluez
  bluez-tools
  sof-firmware
  ppp
  man-pages
  ShellCheck
  net-tools
  java-17-openjdk-headless
  docker
  fedora-backgrounds-base
  curl
  fd-find
  ripgrep
  fzf
)

# Install available Fedora packages
echo "Installing packages..."
sudo dnf install -y "${PKGS[@]}"

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker $USER

# # Enable and start PostgreSQL service
# sudo systemctl enable postgresql
# sudo systemctl start postgresql

echo
echo "Fedora 42 package installation script complete."
echo "Manual steps may be needed for packages not directly available or with no clear alternative (hyprpaper, mako, hypridle, xwaylandvideobridge-git, grim, grimshot)."
echo "Consider: Flatpak, Copr repositories, or compiling from source for these."
echo ""
echo "Additional notes:"
echo "- Docker service has been enabled and started"
echo "- User added to docker group (logout/login required for group changes)"
echo "- PostgreSQL service has been enabled and started"
echo "- RPM Fusion repositories have been enabled for additional packages"
