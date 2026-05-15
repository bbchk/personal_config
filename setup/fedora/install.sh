#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

log "Starting install.sh execution..."

# ====================================
log "Setting up RPM Fusion repositories (Free & Non-Free)..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# ====================================
PKGS=(
  # Development Tools
  gcc gcc-c++ make cmake pkgconf-pkg-config git git-delta maven golang julia php-xdebug xclip glab rustfmt isort re2-devel mysql-devel pipx libXScrnSaver meson
  # Libraries
  openssl-devel openssl激 readline-devel zlib-devel libyaml-devel libffi-devel gdbm-devel ncurses-devel libuuid-devel libssh2-devel libgit2-devel ruby-devel @virtualization virt-manager virt-viewer gnome-keyring-pam xdg-desktop-portal xdg-desktop-portal-gnome
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
  steam
)

log "Preparing to install ${#PKGS[@]} system packages via DNF..."
sudo dnf install -y "${PKGS[@]}" --skip-unavailable

# ====================================

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
flatpak install flathub com.github.ahrm.sioyek -y

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
log "Enabling COPR for 'showmethekey' and installing..."
sudo dnf copr enable pesader/showmethekey -y
sudo dnf install showmethekey -y

# ====================================
if ! command_exists mise; then
  log "Mise runtime manager not found. Installing via mise.run..."
  curl https://mise.run | sh
fi
log "Using Mise to provision latest runtimes"
mise use --global node@latest pnpm@latest glab@latest
# ====================================
#
log "======= install.sh execution finished successfully ======="
