#!/usr/bin/env bash

source /usr/local/share/devcontainer-helpers/utils.sh

log "Starting Ubuntu install.sh execution..."

log "Updating & upgrading local apt registry"
apt update && apt upgrade -y

log "Installing critical base packages first..."
apt install -y sudo curl git make gcc g++ jq gnupg python3-pip python3-venv pipx

log "Installing NVM..."
export NVM_DIR="/usr/local/nvm"
mkdir -p "$NVM_DIR"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | NVM_DIR="$NVM_DIR" bash

# Load nvm for the rest of this script
source "$NVM_DIR/nvm.sh"

log "Installing Node.js LTS via NVM..."
nvm install --lts
nvm alias default node
nvm use default

log "Making node/npm globally accessible for non-interactive shells (Mason, scripts, etc.)..."
NODE_BIN_DIR="$(dirname "$(nvm which current)")"
ln -sf "$NODE_BIN_DIR/node" /usr/local/bin/node
ln -sf "$NODE_BIN_DIR/npm" /usr/local/bin/npm
ln -sf "$NODE_BIN_DIR/npx" /usr/local/bin/npx

log "Setting up NVM in /etc/profile.d so all shells can use it..."
cat > /etc/profile.d/nvm.sh << 'EOF'
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
EOF
chmod +x /etc/profile.d/nvm.sh

log "Verifying node/npm..."
node --version
npm --version

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
  fzf gh tree kitty tmux zsh man-db
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
sudo apt-get install -y "${PKGS[@]}" || true

log "Configuring flathub origin and updating afterwards..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

log "Installing docker"
sudo rm -f /etc/apt/sources.list.d/docker.list /etc/apt/sources.list.d/github-cli.list /etc/apt/keyrings/docker.gpg /usr/share/keyrings/githubcli-archive-keyring.gpg
curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
sudo sh /tmp/get-docker.sh

log "======= Ubuntu install.sh execution finished successfully ======="

