#!/usr/bin/env bash

source /usr/local/share/devcontainer-helpers/utils.sh

log "Starting Ubuntu install.sh execution..."

log "Updating & upgrading local apt registry"
apt update && apt upgrade -y

log "Installing critical base packages first..."
apt install -y sudo curl git make gcc g++ jq gnupg python3-pip python3-venv pipx

log "Preparing to install packages via APT..."
PKGS=(
  # Development Tools
  cmake pkg-config git-delta maven golang php-xdebug
  xclip rustfmt isort libre2-dev libmysqlclient-dev libxss-dev meson
  shellcheck expect xorriso

  # Libraries
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev libgdbm-dev
  libncurses-dev uuid-dev libssh2-1-dev libgit2-dev ruby-dev
  libvirt-daemon-system virt-manager virt-viewer qemu-system-x86
  libpam-gnome-keyring xdg-desktop-portal xdg-desktop-portal-gnome

  # Runtimes
  openjdk-17-jdk lua5.4 luarocks rbenv

  # DevOps
  ansible libarchive-tools oathtool

  # Editors/Shell
  python3-neovim fzf gh tree kitty tmux zsh man-db
  gnome-terminal gnome-tweaks drawing calibre

  # Network
  traceroute ncat dnsutils openfortivpn net-tools nmap

  # Files/System
  fd-find ripgrep zip unzip lsof stow qbittorrent ppp
  android-tools-adb android-tools-fastboot scrcpy
  fonts-firacode fonts-font-awesome

  # Secrets / Keyring
  libsecret-tools

  # Misc
  cups cups-filters system-config-printer sane-utils simple-scan
  lynx poedit gnome-shell-extension-gsconnect python3-nautilus flatpak gnome-software-plugin-flatpak
)
sudo apt install -y "${PKGS[@]}" || true

log "Configuring flathub origin and updating afterwards..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

log "Installing docker"
# Remove stale docker/gh repo entries from previous failed installs (broken GPG keys block apt-get update)
sudo rm -f /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/github-cli.list /etc/apt/keyrings/docker.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

log "======= Ubuntu install.sh execution finished successfully ======="
