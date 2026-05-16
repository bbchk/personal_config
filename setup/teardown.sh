#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

# ====================================

log "Configuring repository remote for push"
git remote set-url --push origin git@github.com:bbchk/personal_config.git

log "Updating the system shell to ZSH and initiating a session logout to apply changes."
chsh -s "$(which zsh)"
