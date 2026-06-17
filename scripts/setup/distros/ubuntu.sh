#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "Starting Ubuntu install.sh execution..."

log "Updating & upgrading local apt registry"
sudo apt update && sudo apt upgrade -y

log "Preparing to install packages via APT..."
PKGS=(
  # Development Tools
  gcc g++ make cmake pkg-config git git-delta maven golang php-xdebug
  xclip rustfmt isort libre2-dev libmysqlclient-dev pipx libxss-dev meson
  python3-pip jq shellcheck expect xorriso

  # Libraries
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev libgdbm-dev
  libncurses-dev uuid-dev libssh2-1-dev libgit2-dev ruby-dev
  qemu-kvm libvirt-daemon-system virt-manager virt-viewer
  libpam-gnome-keyring xdg-desktop-portal xdg-desktop-portal-gnome

  # Runtimes
  python3-venv openjdk-17-jdk lua5.4 luarocks rbenv

  # DevOps
  ansible docker-ce docker-ce-cli containerd.io docker-compose-plugin
  keepassxc libarchive-tools oathtool

  # Editors/Shell
  neovim python3-neovim fzf gh tree kitty tmux zsh man-db
  gnome-terminal gnome-tweaks drawing calibre

  # Network
  traceroute ncat dnsutils openfortivpn net-tools curl nmap

  # Files/System
  fd-find ripgrep zip unzip lsof stow qbittorrent ppp
  android-tools-adb android-tools-fastboot scrcpy
  fonts-firacode fonts-font-awesome

  # Misc
  cups cups-filters system-config-printer sane-utils simple-scan
  lynx poedit gnome-shell-extension-gsconnect python3-nautilus flatpak gnome-software-plugin-flatpak
)
sudo apt install -y "${PKGS[@]}" || true

log "Configuring flathub origin and updating afterwards..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

log "Installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

log "Installing neovim-remote"
pip3 install neovim-remote
sudo install -m 755 -o root -g root \
  "$HOME/pers/scripts/sudoedit-nvr" "/usr/local/bin/sudoedit-nvr"

log "Installing Google Chrome..."
if ! command_exists google-chrome-stable; then
  wget -O /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
  rm /tmp/google-chrome.deb
fi

log "Installing Sioyek PDF viewer via Flatpak..."
flatpak install --user -y flathub com.github.ahrm.sioyek

if ! command_exists keyd; then
  log "Keyd not detected. Commencing source build from GitHub..."
  git -C /tmp clone https://github.com/rvaiya/keyd
  make -C /tmp/keyd && sudo make -C /tmp/keyd install
fi

if ! command_exists tailscale; then
  log "Tailscale not found. Fetching and running official install script..."
  curl -fsSL https://tailscale.com/install.sh | sh
fi

log "======= Ubuntu install.sh execution finished successfully ======="
