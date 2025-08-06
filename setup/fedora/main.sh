#!/usr/bin/env bash

set -euo pipefail



chsh -s "$(which zsh)" # For this to take effect we need to log out and log in back
gnome-session-quit --logout


#  POST CLONE in pers local git repo
 # ╰$ git config core.hooksPath .githooks
 #
 # PRE PULL 
 # git stash push -u -m 'secrets' 
 # POST PULL 
 # git stash pop
 # git checkout --theirs .
 #
 #

# Update system and install essentials
# sudo dnf update -y

# Enable RPM Fusion repositories for additional packages
# sudo dnf install -y \
#   https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
#   https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

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

# Enable and start Docker service
sudo systemctl enable docker
sudo systemctl start docker
sudo usermod -aG docker "$USER"
