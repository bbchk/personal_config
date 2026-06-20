#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

REPO="${REPO:-https://github.com/bbchk/personal_config.git}"
TARGET_PATH="${TARGET_PATH:-/root/pers}"
DOTFILES_DIR="${DOTFILES_DIR:-dotfiles}"
BRANCH="${BRANCH:-main}"

# ---- Clone repo -------------------------

log "Cloning $REPO (branch: $BRANCH) into $TARGET_PATH..."
git clone --depth=1 --branch "$BRANCH" "$REPO" "$TARGET_PATH"

# ---- Submodules -------------------------

log "Initializing and updating git submodules..."
git -C "$TARGET_PATH" submodule update --init --recursive

# ---- Shell -------------------------

log "Setting default shell to zsh..."
if command -v zsh &>/dev/null; then
  [[ "$SHELL" == */zsh ]] || usermod -s "$(which zsh)" root
else
  log "WARNING: zsh not found, skipping shell change."
fi

# ---- Dotfiles symlinks -------------------------

log "Scanning $TARGET_PATH/$DOTFILES_DIR for items to symlink into $HOME..."
DOTFILES_FULL="$TARGET_PATH/$DOTFILES_DIR"

if [ ! -d "$DOTFILES_FULL" ]; then
  log "WARNING: dotfiles dir '$DOTFILES_FULL' not found, skipping symlinks."
else
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
fi

# ---- System-level config files -------------------------

CUSTOM_DIR="$DOTFILES_FULL/.custom/sys"

if [ -f "$CUSTOM_DIR/hosts" ]; then
  log "Copying custom /etc/hosts..."
  cp "$CUSTOM_DIR/hosts" /etc/hosts
fi

if [ -f "$CUSTOM_DIR/sudoers" ]; then
  log "Copying sudoers to /etc/sudoers.d/sudoers..."
  cp "$CUSTOM_DIR/sudoers" /etc/sudoers.d/sudoers
  chmod 440 /etc/sudoers.d/sudoers
fi

# ---- SSH key permissions -------------------------

log "Fixing SSH key permissions..."
find "$TARGET_PATH/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

# ---- neovim-remote + sudoedit-nvr -------------------------

if command -v pipx &>/dev/null; then
  log "Installing neovim-remote via pipx..."
  pipx install neovim-remote

  NVR_SCRIPT="$TARGET_PATH/scripts/sudoedit-nvr"
  if [ -f "$NVR_SCRIPT" ]; then
    log "Installing sudoedit-nvr to /usr/local/bin..."
    install -m 755 -o root -g root "$NVR_SCRIPT" "/usr/local/bin/sudoedit-nvr"
  else
    log "WARNING: $NVR_SCRIPT not found, skipping sudoedit-nvr install."
  fi
else
  log "WARNING: pipx not found, skipping neovim-remote install."
fi

# ---- Neovim plugin sync -------------------------

if command -v nvim &>/dev/null; then
  log "Syncing Neovim plugins via Lazy (headless)..."
  nvim --headless -c "Lazy! sync" -c "qa!" 2>&1 | tee /tmp/lazy_sync.log || true
else
  log "WARNING: nvim not found, skipping plugin sync. Make sure the neovim feature runs before this one."
fi

log "personal-config feature install complete!"
log ""
log "NOTE: The following require mounted GPG keys and must stay in a postCreateCommand or lifecycle script:"
log "  - GPG key import + trust"
log "  - Secret decryption (git checkout -- .)"
log "  - Docker daemon config (requires running docker)"

# chmod 700 /root/.gnupg
# gpg --import /root/.gnupg/devcon-public.asc
# echo "KEY_ID:6:" | gpg --import-ownertrust
# git -C "$HOME/pers" checkout -- .   # decrypt secrets
# sudo systemctl enable --now docker
# sudo usermod -aG docker "$USER"
# sudo cp "$HOME/pers/dotfiles/.custom/deamon.json" /etc/docker/daemon.json
