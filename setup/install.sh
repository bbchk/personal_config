#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

log "Starting install.sh execution..."

# ====================================
log "Setting up RPM Fusion repositories (Free & Non-Free)..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# ====================================
log "Configuring flathub origin for flatpak and updating afterwards..."

flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

# ====================================
log "Updating DNF"

sudo dnf update -y --skip-unavailable --exclude=openh264

# ====================================
PKGS=(
  # Development Tools
  gcc gcc-c++ make cmake pkgconf-pkg-config git git-delta maven golang julia php-xdebug xclip glab rustfmt isort re2-devel mysql-devel pipx libXScrnSaver meson python3-pip jq
  # Libraries
  openssl-devel readline-devel zlib-devel libyaml-devel libffi-devel gdbm-devel ncurses-devel libuuid-devel libssh2-devel libgit2-devel ruby-devel @virtualization virt-manager virt-viewer gnome-keyring-pam xdg-desktop-portal xdg-desktop-portal-gnome
  # Runtimes
  python3-venv java-17-openjdk lua luarocks rbenv
  # DevOps
  ansible docker docker-compose ShellCheck keepassxc bsdtar k9s oathtool expect xorriso
  # Editors/Shell
  neovim fzf gh tree kitty tmux zsh man-pages gnome-terminal gnome-tweaks drawing calibre
  # Network
  traceroute nmap-ncat bind-utils openfortivpn net-tools curl nmap
  # Files/System
  fd-find ripgrep zip unzip lsof stow qbittorrent swappy ppp android-tools scrcpy fira-code-fonts fontawesome-fonts
  # Misc
  steam cups cups-filters system-config-printer sane-backends sane-frontends simple-scan lynx
)

log "Preparing to install ${#PKGS[@]} packages via DNF..."
sudo dnf install -y "${PKGS[@]}" --skip-unavailable

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
sudo ln -sf "$HOME/pers/config/deamon.json" /etc/docker/deamon.json

# ====================================
log "Enabling Google Chrome repositories and installing stable branch..."
sudo dnf -y install fedora-workstation-repositories
sudo dnf -y config-manager setopt google-chrome.enabled=1
sudo dnf -y install google-chrome-stable

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
  sudo cp "$HOME/pers/config/keyd.conf" /etc/keyd/default.conf
  sudo keyd reload
  sudo usermod -aG keyd "$USER"
fi

# ====================================
if ! command_exists tailscale; then
  log "Tailscale not found. Fetching and running official install script..."
  curl -fsSL https://tailscale.com/install.sh | sh
fi

# ====================================
if ! command_exists mise; then
  log "Mise runtime manager not found. Installing via mise.run..."
  curl https://mise.run | sh
fi
log "Using Mise to install all runtimes from config"
mise install
# ====================================

log "======= install.sh execution finished successfully ======="
