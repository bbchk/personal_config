#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

# ====================================

log "Configuring repository remotes and initializing local Git filters."
git remote set-url --push origin git@github.com:bbchk/personal_config.git
git config --local filter.gpg.clean "/home/bch/pers/scripts/gpg-clean"
git config --local filter.gpg.smudge "/home/bchk/pers/scripts/gpg-smudge"
git config --local filter.gpg.required true
git config --local diff.gpg.textconv "/home/bchk/pers/scripts/gpg-diff"

log "Updating the system shell to ZSH and initiating a session logout to apply changes."
chsh -s "$(which zsh)"
