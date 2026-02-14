#!/usr/bin/env bash

log "Starting config.sh execution..."

source "$HOME/pers/setup/common/utils.sh"

# ---- submodules ---------------------------
log "Initializing and updating git submodules..."
git submodule update --init --recursive

# ---- dotfiles ---------------------------
log "Scanning $HOME/pers/dotfiles for items to symlink..."

dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
for i in "${dotfiles_to_symlink[@]}"; do
  base_item_name=$(basename "$i")
  log "Linking $i -> $HOME/$base_item_name"
  mv "$HOME/$base_item_name" "$HOME/${base_item_name}.backup" 2>/dev/null
  ln -sf "$i" "$HOME/$base_item_name"
done

# ---- secrets ---------------------------
log "Decrypting secret files using ansible-vault..."
find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;

mv "$HOME/.ssh" "$HOME/.ssh.backup" 2>/dev/null
ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"

mkdir -p "$HOME/pers/dotfiles/.config/keepassxc"
ln -sf "$HOME/pers/secrets/passwords/keepassxc.ini" "$HOME/pers/dotfiles/.config/keepassxc/keepassxc.ini"

log "Symlinking custom /etc/hosts file..."
mv /etc/hosts /etc/hosts.backup
sudo ln -sf "$HOME/pers/secrets/hosts" /etc/hosts

# ---- shortcuts ---------------------------
log "Configuring GNOME custom keybindings (Sessionizer, Swappy, Flameshot)..."
K1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
K2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
K3="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"

log "Registering keybinding paths in gsettings..."
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$K1', '$K2', '$K3']"

log "Setting binding: <Super>f -> Sessionizer"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 name 'Sessionizer'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 command "kitty -e $HOME/pers/scripts/sessionizer"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 binding '<Super>f'

log "Setting binding: <Super>o -> Swappy"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 name 'Swappy'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 command "bash -c 'gnome-screenshot -f /tmp/screenshot.png && swappy -f /tmp/screenshot.png'"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 binding '<Super>o'

log "Setting binding: <Super>[ -> Flameshot"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 command "$HOME/pers/scripts/flameshot.sh --raw | wl-copy"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 binding '<Super>['

# ---- autostart ---------------------------
log "Creating GNOME autostart directory at ~/.config/autostart..."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/nvim-sessionizer.desktop << EOF
[Desktop Entry]
Type=Application
Name=Neovim Sessionizer
Exec=gnome-terminal -- nvim -c "lua require('custom.sessionizer').sessionizer()"
Icon=utilities-terminal
Comment=Starts Neovim with the sessionizer plugin
EOF

log "======= config.sh execution finished successfully ======="
