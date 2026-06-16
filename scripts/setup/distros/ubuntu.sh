#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "Starting Ubuntu install.sh execution..."

# ====================================
log "Adding required PPAs and external repositories..."

# Neovim (latest stable)
sudo add-apt-repository -y ppa:neovim-ppa/unstable

# GitHub CLI
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg >/dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null

# Docker (official repo)
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

# ====================================
log "Configuring flathub origin for flatpak and updating afterwards..."

sudo apt install -y flatpak gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update -y

# ====================================
log "Updating APT"

sudo apt update && sudo apt upgrade -y

# ====================================
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
  neovim fzf gh tree kitty tmux zsh man-db
  gnome-terminal gnome-tweaks drawing calibre

  # Network
  traceroute ncat dnsutils openfortivpn net-tools curl nmap

  # Files/System
  fd-find ripgrep zip unzip lsof stow qbittorrent ppp
  android-tools-adb android-tools-fastboot scrcpy
  fonts-firacode fonts-font-awesome

  # Misc
  cups cups-filters system-config-printer sane-utils simple-scan
  lynx poedit gnome-shell-extension-gsconnect python3-nautilus
)

log "Preparing to install ${#PKGS[@]} packages via APT..."
sudo apt install -y "${PKGS[@]}" || true

# ====================================

log "Installing neovim-remote"

pip3 install neovim-remote
sudo cp /home/bchk/pers/scripts/sudoedit-nvr /usr/local/bin/sudoedit-nvr
sudo chown root:root /usr/local/bin/sudoedit-nvr
sudo chmod 755 /usr/local/bin/sudoedit-nvr

# ====================================
log "Configuring Docker daemon and user groups..."
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"
sudo mkdir -p /etc/docker
sudo mv /etc/docker/daemon.json /etc/docker/daemon.json.old 2>/dev/null
sudo cp "$HOME/pers/dotfiles/.custom/deamon.json" /etc/docker/daemon.json

# ====================================
log "Installing Google Chrome..."
if ! command_exists google-chrome-stable; then
  wget -O /tmp/google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo dpkg -i /tmp/google-chrome.deb || sudo apt install -f -y
  rm /tmp/google-chrome.deb
fi

# ====================================
log "Installing Sioyek PDF viewer via Flatpak..."
flatpak install --user -y flathub com.github.ahrm.sioyek

# ====================================
if ! command_exists keyd; then
  log "Keyd not detected. Commencing source build from GitHub..."
  cd "/tmp" || exit
  git clone https://github.com/rvaiya/keyd
  cd keyd || exit
  log "Compiling and installing Keyd..."
  make && sudo make install
  cd - || exit
  log "Configuring Keyd service and loading default.conf..."
  sudo systemctl enable keyd --now
  sudo cp "$HOME/pers/dotfiles/.custom/keyd.conf" /etc/keyd/default.conf
  sudo keyd reload
  sudo usermod -aG keyd "$USER"
fi

# ====================================
if ! command_exists tailscale; then
  log "Tailscale not found. Fetching and running official install script..."
  curl -fsSL https://tailscale.com/install.sh | sh
fi

# ====================================

log "======= Ubuntu install.sh execution finished successfully ======="
