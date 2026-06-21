#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "\n\n ======= devcon.sh is starting ======= \n\n"

log "Configuring Docker daemon and user groups..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo mv /etc/docker/daemon.json{,.old}
sudo cp "$HOME/pers/dotfiles/.custom/deamon.json" /etc/docker/daemon.json
