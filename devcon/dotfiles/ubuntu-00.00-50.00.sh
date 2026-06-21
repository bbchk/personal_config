#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

REPO="${REPO:-https://github.com/bbchk/personal_config.git}"
TARGET_PATH="${TARGET_PATH:-/root/pers}"
DOTFILES_DIR="${DOTFILES_DIR:-dotfiles}"
BRANCH="${BRANCH:-main}"

log "Importing gpg keys"
chmod 700 /root/.gnupg
gpg --import /root/.gnupg/devcon-public.asc
gpg --list-keys --with-colons \
    | awk -F: '/^fpr/{print $10":6:"; exit}' \
    | gpg --import-ownertrust

log "Cloning $REPO (branch: $BRANCH) into $TARGET_PATH..."
git clone --depth=1 --branch "$BRANCH" "$REPO" "$TARGET_PATH"

log "Initializing and updating git submodules..."
git -C "$TARGET_PATH" submodule update --init --recursive

log "Setting default shell to zsh..."
[[ "$SHELL" == */zsh ]] || usermod -s "$(which zsh)" root

log "Scanning $TARGET_PATH/$DOTFILES_DIR for items to symlink into $HOME..."
DOTFILES_FULL="$TARGET_PATH/$DOTFILES_DIR"
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
NVR_SCRIPT="$TARGET_PATH/scripts/sudoedit-nvr"
install -m 755 -o root -g root "$NVR_SCRIPT" "/usr/local/bin/sudoedit-nvr"

log "Decrypting secrets..."
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions..."
find "$TARGET_PATH/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers to /etc/sudoers.d/sudoers..."
CUSTOM_DIR="$DOTFILES_FULL/.custom/sys"
cp "$CUSTOM_DIR/sudoers" /etc/sudoers.d/sudoers
chmod 440 /etc/sudoers.d/sudoers

log "personal-config feature install complete!"
