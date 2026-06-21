#!/usr/bin/env bash

source /usr/local/share/devcontainer-helpers/utils.sh

log "Starting Ubuntu install.sh execution..."

log "Updating & upgrading local apt registry"
apt-get update && apt-get upgrade -y

log "Installing critical base packages first..."
apt-get install -y sudo curl git make gcc g++ jq gnupg python3-pip python3-venv pipx

log "Preparing to install packages via APT..."
PKGS=(
  # Development Tools
  cmake pkg-config php-xdebug
  rustfmt isort libre2-dev libmysqlclient-dev meson
  shellcheck expect

  # Libraries
  libssl-dev libreadline-dev zlib1g-dev libyaml-dev libffi-dev libgdbm-dev
  libncurses-dev uuid-dev libssh2-1-dev libgit2-dev ruby-dev

  # Runtimes
  openjdk-17-jdk lua5.4 luarocks
  rbenv

  # DevOps
  ansible libarchive-tools oathtool

  # Editors/Shell
  fzf tree tmux zsh man-db

  # Network
  traceroute ncat dnsutils net-tools nmap
  openfortivpn

  # Files/System
  fd-find ripgrep zip unzip lsof stow

  # Secrets / Keyring
  libsecret-tools

  # Java
  maven
)
apt-get install -y "${PKGS[@]}" || true

log "======= Ubuntu install.sh execution finished successfully ======="

