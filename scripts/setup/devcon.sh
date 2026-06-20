#!/usr/bin/env bash

source "$HOME/pers/scripts/utils.sh"

log "\n\n ======= index_devcon.sh is starting ======= \n\n"

chmod 700 /root/.gnupg
gpg --import /root/.gnupg/devcon-public.asc

GPG_KEY_ID="E78A0D774F0BDAC50F897DC5FF99608021A353C0"
if ! gpg --list-secret-keys "$GPG_KEY_ID" >/dev/null 2>&1; then
  echo "ERROR: GPG key not found. Import it first:"
  echo "  gpg --import ~/path/to/your/gpg/public_key.asc"
  echo "  gpg --import ~/path/to/your/gpg/private_key.asc"
  exit 1
fi

log "Setting appropriate trust level for gpg key"
echo "$GPG_KEY_ID:6:" | gpg --import-ownertrust

log "Updating the system shell to zsh."
[[ "$SHELL" == */zsh ]] || sudo usermod -s "$(which zsh)" "$USER"

# ---- submodules ---------------------------
log "Initializing and updating git submodules..."
git submodule update --init --recursive

# ---- config ---------------------------

# log "Configuring Keyd service and loading default.conf..."
# sudo systemctl enable keyd --now
# sudo cp "$HOME/pers/dotfiles/.custom/keyd.conf" /etc/keyd/default.conf
# sudo keyd reload
# sudo usermod -aG keyd "$USER"

log "Configuring Docker daemon and user groups..."
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"
sudo mv /etc/docker/daemon.json{,.old}
sudo cp "$HOME/pers/dotfiles/.custom/deamon.json" /etc/docker/daemon.json

# ---- dotfiles ---------------------------

log "Scanning $HOME/pers/dotfiles for items to symlink..."
dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
for i in "${dotfiles_to_symlink[@]}"; do
  base_item_name=$(basename "$i")
  target="$HOME/$base_item_name"

  # Skip if already correctly linked
  [[ -L "$target" && "$(readlink "$target")" == "$i" ]] && continue

  log "Linking $i -> $target"
  [[ -e "$target" || -L "$target" ]] && mv --no-target-directory "$target" "${target}.backup" 2>/dev/null
  ln -sfnT "$i" "$target"
done

log "Syncing Neovim plugins..."
nvim --headless -c "Lazy! sync" -c "qa!" 2>/dev/null || true

log "Decrypting all secrets..."
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions (600 for private keys)..."
find "$HOME/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} +

log "Copying custom /etc/hosts file..."
sudo cp "$HOME/pers/dotfiles/.custom/sys/hosts" /etc/hosts

log "Copying pers/secrets/sudoers file for /etc/sudoers.d/sudoers ..."
sudo cp "$HOME/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers

log "Installing neovim-remote"
pipx install neovim-remote
sudo install -m 755 -o root -g root \
  "$HOME/pers/scripts/sudoedit-nvr" "/usr/local/bin/sudoedit-nvr"
