#!/usr/bin/env bash

set -euo pipefail

# ====================================

# TODO: stow dotfiles
cd "$HOME"
stow -t "$HOME" dotfiles

# TODO: stow ssh

read -rp "Enter pretty hostname: " pretty_hostname
sudo hostnamectl set-hostname --pretty "$pretty_hostname"

read -rp "Enter static hostname: " static_hostname
sudo hostnamectl set-hostname --static "$static_hostname"
