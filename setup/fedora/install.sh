#!/usr/bin/env bash

set -euo pipefail

# ====================================

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
  
  # Programming Languages & Runtimes
  python3-venv
  java-17-openjdk
  lua
  luarocks
  rbenv
  
  # System Administration & DevOps
  ansible
  docker
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
  
  # Fonts
  fira-code-fonts
  fontawesome-fonts
)

echo "Installing packages..."
sudo dnf install -y "${PKGS[@]}" --skip-unavailable


# OMZ below

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Docker below

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"

# K8s below

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
kubectl version --client

# TODO:I am not sure about krew
# (
#   set -x; cd "$(mktemp -d)" &&
#   OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
#   ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
#   KREW="krew-${OS}_${ARCH}" &&
#   curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
#   tar zxvf "${KREW}.tar.gz" &&
#   ./"${KREW}" install krew
# )
#
# export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
#
# kubectl krew install ns
# kubectl krew install ctx


# todo below?
