#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

# ====================================

log "Configuring repository remotes and initializing local Git hooks."
git remote set-url --push origin git@github.com:USERNAME/REPOSITORY.git
git config core.hooksPath .githooks

log "Updating the system shell to ZSH and initiating a session logout to apply changes."
chsh -s "$(which zsh)"
