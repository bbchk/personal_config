#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "Starting install.sh execution..."


log "Setting up RPM Fusion repositories (Free & Non-Free)..."
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

log "Configuring flathub origin for flatpak and updating afterwards..."
flatpak remote-add --if-not-exists --user flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak update

log "Updating & upgrading local dnf registry"
sudo dnf update -y --skip-unavailable --exclude=openh264

log "Preparing to install packages via DNF..."
PKGS=(
  # Development Tools
  gcc gcc-c++ make cmake pkgconf-pkg-config git maven golang golang-x-tools-gopls julia php-xdebug xclip glab rustfmt isort re2-devel mysql-devel pipx libXScrnSaver meson python3-pip jq clang-tools-extra
  # Libraries
  openssl-devel readline-devel zlib-devel libyaml-devel libffi-devel gdbm-devel ncurses-devel libuuid-devel libssh2-devel libgit2-devel ruby-devel @virtualization virt-manager virt-viewer gnome-keyring-pam xdg-desktop-portal xdg-desktop-portal-gnome langpacks-en glibc-langpack-en
  # Runtimes
  python3-venv java-17-openjdk lua luarocks rbenv
  # DevOps
  ansible ShellCheck keepassxc bsdtar k9s oathtool expect xorriso
  # Editors/Shell
  neovim fzf gh tree kitty tmux zsh man-pages gnome-terminal gnome-tweaks drawing calibre
  # Network
  traceroute nmap-ncat bind-utils openfortivpn net-tools curl nmap
  # Files/System
  fd-find ripgrep zip unzip lsof stow qbittorrent swappy ppp android-tools scrcpy fira-code-fonts fontawesome-fonts
  # Misc
  steam cups cups-filters system-config-printer sane-backends sane-frontends simple-scan lynx poedit gnome-shell-extension-gsconnect nautilus-python
)
sudo dnf install -y "${PKGS[@]}" --skip-unavailable

# TODO: devcontainers
curl -fsSL https://raw.githubusercontent.com/devcontainers/cli/main/scripts/install.sh | sh

# TODO: install pkgs for lsp servers
# npm i -g vscode-langservers-extracted   # cssls + eslint + html + jsonls
# npm i -g intelephense
# npm i -g pyright
# npm i -g sql-language-server
# npm i -g @tailwindcss/language-server
# npm i -g typescript typescript-language-server
# npm i -g stylelint

log "Installing docker"
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh ./get-docker.sh

log "Installing neovim-remote"
pip3 install neovim-remote
sudo install -m 755 -o root -g root \
  "$HOME/pers/scripts/sudoedit-nvr" "/usr/local/bin/sudoedit-nvr"

log "Enabling Google Chrome repositories and installing stable branch..."
sudo dnf -y install fedora-workstation-repositories
sudo dnf -y config-manager setopt google-chrome.enabled=1
sudo dnf -y install google-chrome-stable

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

log "======= install.sh execution finished successfully ======="
