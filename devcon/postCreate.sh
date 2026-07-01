#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

# This script now runs as the non-root user "bchk" (see remoteUser in the
# definitions). updateRemoteUserUID syncs bchk's uid/gid to the host user that
# owns the bind-mounted ~/pers, so completion dirs are no longer flagged by
# compaudit. Privileged steps below go through passwordless sudo (granted to
# bchk by the common-utils feature).

log "Setting default shell to zsh..."
[[ "$SHELL" == */zsh ]] || sudo usermod -s "$(command -v zsh)" "$(id -un)"

log "Scanning $HOME/pers/dotfiles for items to symlink into $HOME..."
DOTFILES_FULL="$HOME/pers/dotfiles"
while IFS= read -r -d '' item; do
  base_item_name=$(basename "$item")
  target="$HOME/$base_item_name"

  # Skip dot-custom (system-level files handled separately below)
  [[ "$base_item_name" == ".custom" ]] && continue

  # Skip if already correctly linked
  [[ -L "$target" && "$(readlink "$target")" == "$item" ]] && continue

  log "Linking $item -> $target"
  [[ -e "$target" || -L "$target" ]] && mv --no-target-directory "$target" "${target}.backup" 2>/dev/null || true
  ln -sfnT "$item" "$target"
done < <(find "$DOTFILES_FULL" -maxdepth 1 -mindepth 1 -print0)

log "Installing neovim-remote"
pipx install neovim-remote
NVR_SCRIPT="$HOME/pers/scripts/sudoedit-nvr"
sudo install -m 755 -o root -g root "$NVR_SCRIPT" "/usr/local/bin/sudoedit-nvr"

log "Importing gpg keys..."
# The .gnupg dir is created by the bind mounts as root; take ownership of the
# dir itself (not -R, so we don't touch the mounted socket/key files).
sudo chown "$(id -u):$(id -g)" "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"

# Prevent GPG from trying to start its own agent.
# The host agent is forwarded via the mounted socket.
echo "no-autostart" >>"$HOME/.gnupg/gpg.conf"

gpg --import "$HOME/.gnupg/devcon-public.asc"
gpg --list-keys --with-colons |
  awk -F: '/^fpr/{print $10":6:"; exit}' |
  gpg --import-ownertrust

log "Decrypting secrets..."
git -C "$HOME/pers" config --global --add safe.directory "$HOME/pers"
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions..."
find "$HOME/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers..."
sudo cp "$HOME/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers
sudo chmod 440 /etc/sudoers.d/sudoers

log "Syncing Neovim plugins..."
nvim --headless -c "Lazy! sync" -c "qa!" 2>/dev/null || true

log "postCreate complete"
