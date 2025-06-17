#!/usr/bin/env bash

set -euo pipefail

# Update system and install essentials
sudo apt update
sudo apt upgrade -y

# Debian package equivalents (where available)
PKGS=(
  tree
  git
  keepassxc
  tmux
  neovim
  openfortivpn
  fzf
  gh
  zsh
  brightnessctl
  pavucontrol
  blueman
  stow
  android-tools-adb
  nautilus
  qbittorrent
  mpv
  golang
  lua5.4
  acpi
  keychain
  man
  zip
  unzip
  lsof
  fonts-firacode
  fonts-font-awesome
  bluez
  bluez-tools
  firmware-sof-signed
  postgresql
  ppp
  manpages
  shellcheck
  kubectl
  net-tools
  default-jre
  docker.io
  desktop-base
  curl
)

# Not available directly or have non-obvious Debian parallels:
# - hyprpaper, grim, mako, hypridle, difftastic,
# - github-cli (available as 'gh'), code (see below), shfmt, grimshot, pnpm, bruno, xwaylandvideobridge-git, aws-cli-v2, sioyek, postman

# Install available Debian packages
echo "Installing packages..."
sudo apt install -y "${PKGS[@]}"


# Extra tools/packages installs

# 1. Visual Studio Code
if ! command -v code >/dev/null 2>&1; then
  echo "Installing Visual Studio Code..."
  wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/ms_vscode.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ms_vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  sudo apt update
  sudo apt install -y code
fi

# 2. shfmt
if ! command -v shfmt >/dev/null 2>&1; then
  echo "Installing shfmt..."
  sudo curl -L "https://github.com/mvdan/sh/releases/latest/download/shfmt_v3.7.0_linux_amd64" -o /usr/local/bin/shfmt
  sudo chmod +x /usr/local/bin/shfmt
fi

# 3. Difftastic
if ! command -v difft >/dev/null 2>&1; then
  echo "Installing difftastic..."
  curl -LO https://github.com/Wilfred/difftastic/releases/latest/download/difft-x86_64-unknown-linux-musl.tar.gz
  tar -xzf difft-x86_64-unknown-linux-musl.tar.gz
  sudo mv difft /usr/local/bin/
  rm -f difft-x86_64-unknown-linux-musl.tar.gz
fi

# 4. gh (GitHub CLI)
if ! command -v gh >/dev/null 2>&1; then
  echo "Installing GitHub CLI..."
  type -p curl >/dev/null || sudo apt install curl -y
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
  sudo apt update
  sudo apt install -y gh
fi

# 5. PNPM
if ! command -v pnpm >/dev/null 2>&1; then
  echo "Installing pnpm..."
  curl -fsSL https://get.pnpm.io/install.sh | sh -
fi

# 6. Google Chrome
if ! command -v google-chrome >/dev/null 2>&1; then
  wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  sudo apt install -y ./google-chrome-stable_current_amd64.deb || true
  rm -f google-chrome-stable_current_amd64.deb
fi

# 7. AWS CLI v2
if ! command -v aws >/dev/null 2>&1; then
  echo "Installing AWS CLI v2..."
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
  unzip -q /tmp/awscliv2.zip -d /tmp
  sudo /tmp/aws/install
  rm -rf /tmp/aws /tmp/awscliv2.zip
fi

# 8. Postman
if ! command -v postman >/dev/null 2>&1; then
  echo "Installing Postman (as snap)..."
  sudo snap install postman
fi

# 9. Bruno (https://github.com/usebruno/bruno)
if ! command -v bruno >/dev/null 2>&1; then
  echo "Installing Bruno..."
  BRUNO_DEB=$(curl -s https://api.github.com/repos/usebruno/bruno/releases/latest | grep browser_download_url | grep deb | cut -d '"' -f 4 | head -n1)
  wget "$BRUNO_DEB" -O /tmp/bruno.deb
  sudo apt install -y /tmp/bruno.deb || true
  rm -f /tmp/bruno.deb
fi

# 10. Sioyek PDF viewer
if ! command -v sioyek >/dev/null 2>&1; then
  echo "Installing Sioyek..."
  wget https://github.com/ahrm/sioyek/releases/latest/download/sioyek-release-linux-portable.tar.xz -O /tmp/sioyek.tar.xz
  mkdir -p ~/opt/sioyek
  tar -xf /tmp/sioyek.tar.xz -C ~/opt/sioyek --strip-components=1
  sudo ln -sf ~/opt/sioyek/sioyek /usr/local/bin/sioyek
  rm /tmp/sioyek.tar.xz
fi

# 11. shellcheck (Debian repo), lua (lua5.4), keychain (keychain), bluez-tools used for bluez-utils, etc.

echo
echo "Debian Bookworm package installation script complete."
echo "Manual steps may be needed for packages not directly available or with no clear alternative (hyprpaper, mako, hypridle, xwaylandvideobridge-git, grim, grimshot)."
echo "Consider: Flatpak, Snap, or compiling from source for these."
