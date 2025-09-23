#!/usr/bin/env bash

# set -euo pipefail

# ====================================
echo -e "\n\n ======= install.sh is starting ======= \n\n"

# Enable RPM Fusion repositories for additional packages
sudo dnf install -y \
  https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
  https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

PKGS=(
  # Development Tools & Build Dependencies
  gcc
  gcc-c++
  make
  cmake
  pkgconf-pkg-config
  git
  git-delta
  maven
  golang
  julia

  # Development Libraries
  openssl-devel
  openssl
  readline-devel
  zlib-devel
  libyaml-devel
  libffi-devel
  gdbm-devel
  ncurses-devel
  libuuid-devel
  libssh2-devel
  libgit2-devel
  ruby-devel
  @virtualization
  virt-manager
  virt-viewer

  # Programming Languages & Runtimes
  python3-venv
  java-17-openjdk
  lua
  luarocks
  rbenv

  # System Administration & DevOps
  ansible
  docker
  docker-compose
  ShellCheck

  # Text Editors & Development Environment
  neovim
  tmux
  fzf
  gh
  tree
  kitty

  # Shell & Terminal
  zsh
  man-pages

  # Network Tools
  traceroute
  nmap-ncat
  bind-utils
  openfortivpn
  net-tools
  curl
  nmap

  # File Management & Search
  fd-find
  ripgrep
  zip
  unzip
  lsof
  stow

  # Desktop Environment & GUI Applications
  qbittorrent

  # System Control & Hardware
  ppp

  # Mobile Development
  android-tools
  scrcpy

  # Fonts
  fira-code-fonts
  fontawesome-fonts
)

echo "Installing packages..."
sudo dnf install -y "${PKGS[@]}" --skip-unavailable

# Docker below

sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

sudo mkdir -p /etc/docker
sudo ln -sf "$HOME/pers/config/deamon.json" /etc/docker/deamon.json

# K8s below

read -rp "Do you want to install kubectl? (y/n): " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  echo "Installing kubectl..."

  # Download kubectl and its sha256 checksum
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

  # Verify the downloaded file's checksum
  echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

  # Install kubectl to /usr/local/bin
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

  # Verify kubectl installation
  kubectl version --client

  echo "kubectl has been installed successfully."

else
  echo "Skipping kubectl installation."
fi

read -rp "Do you want to install GitHub CLI? (y/n): " github_cli_res
if [[ "$github_cli_res" =~ ^[Yy]$ ]]; then
  sudo dnf install dnf5-plugins
  sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
  sudo dnf install gh --repo gh-cli
fi

# TODO: implement
# read -rp "Do you want to install git-who? (y/n): " git_who_res
# if [[ "$git_who_res" =~ ^[Yy]$ ]]; then
#
#   cd "/tmp"
#   git clone git@github.com:sinclairtarget/git-who.git
#   cd git-who
#   rake
#
#   sudo cp git-who /usr/local/bin/
#
#   cd -
#   git-who --version
# fi

read -rp "Do you want to install google-chrome? (y/n): " google_chrome_res
if [[ "$google_chrome_res" =~ ^[Yy]$ ]]; then
  sudo dnf install fedora-workstation-repositories
  sudo dnf config-manager setopt google-chrome.enabled=1
  sudo dnf install google-chrome-stable
fi

read -rp "Do you want to install sioyek? (y/n): " sioyek_res
if [[ "$sioyek_res" =~ ^[Yy]$ ]]; then
  flatpak install flathub com.github.ahrm.sioyek
  flatpak run com.github.ahrm.sioyek
fi

read -rp "Do you want to install julia? (y/n): " julia_res
if [[ "$julia_res" =~ ^[Yy]$ ]]; then
  curl -fsSL https://install.julialang.org | sh
fi

read -rp "Do you want to install keyd? (y/n): " keyd_res
if [[ "$keyd_res" =~ ^[Yy]$ ]]; then

  cd "/tmp"
  git clone https://github.com/rvaiya/keyd
  cd keyd

  make && sudo make install

  cd -
  sudo systemctl enable keyd --now
  sudo cp "$HOME/pers/config/keyd.conf" /etc/keyd/default.conf
  sudo keyd reload

  sudo usermod -aG keyd "$USER"
fi
