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
  cmake pkg-config git-delta golang php-xdebug
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
  fzf gh tree tmux zsh man-db

  # Network
  traceroute ncat dnsutils net-tools nmap
  openfortivpn

  # Files/System
  fd-find ripgrep zip unzip lsof stow

  # Secrets / Keyring
  libsecret-tools gnupg

  # Java
  maven
)
sudo apt-get install -y "${PKGS[@]}" || true

log "Installing docker"
sudo rm -f /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/github-cli.list /etc/apt/keyrings/docker.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

log "======= Ubuntu install.sh execution finished successfully ======="

