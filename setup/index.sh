#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

log "\n\n ======= index.sh is starting ======= \n\n"

# ====================================

GPG_KEY_ID="E78A0D774F0BDAC50F897DC5FF99608021A353C0"
if ! gpg --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1; then
  echo "ERROR: GPG key not found. Import it first:"
  echo "  gpg --import ~/path/to/your/gpg/key.key"
  exit 1
fi

# ====================================

log "Configuring repository remote for push"
git -C "$HOME/pers" remote set-url --push origin git@github.com:bbchk/personal_config.git

# ====================================

log "Updating the system shell to zsh."
[[ "$SHELL" == */zsh ]] || chsh -s "$(which zsh)"

# ====================================

"$HOME/pers/setup/install.sh"
"$HOME/pers/setup/config.sh"
"$HOME/pers/setup/gnome.sh"
"$HOME/pers/setup/filesystem.sh"

"$HOME/pers/scripts/connect_vpn.sh"

read -rp "Setup complete. Press Enter to close..."
