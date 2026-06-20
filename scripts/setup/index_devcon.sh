#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "\n\n ======= index_devcon.sh is starting ======= \n\n"

GPG_KEY_ID="E78A0D774F0BDAC50F897DC5FF99608021A353C0"
if ! gpg --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1; then
  echo "ERROR: GPG key not found. Import it first:"
  echo "  gpg --import ~/path/to/your/gpg/public_key.asc"
  echo "  gpg --import ~/path/to/your/gpg/private_key.asc"
  exit 1
fi

log "Setting appropriate trust level for gpg key"
echo "$GPG_KEY_ID:6:" | gpg --import-ownertrust

log "Configuring repository remote for push"
git -C "$HOME/pers" remote set-url --push origin git@github.com:bbchk/personal_config.git

log "Updating the system shell to zsh."
[[ "$SHELL" == */zsh ]] || sudo usermod -s "$(which zsh)" "$USER"

DISTRO="$1"

"$HOME/pers/scripts/setup/config.sh"
