#!/usr/bin/env bash

source "$HOME/pers/setup/utils.sh"

git submodule update --init --recursive

# ====================================
#
echo -e "\n\n ======= config.sh is starting ======= \n\n"

# ---- dotfiles ---------------------------
confirm "Do you want to link dotfiles?" do_dotfiles
if $do_dotfiles; then
  dotfiles_to_symlink=($(find "$HOME/pers/dotfiles" -maxdepth 1 -mindepth 1))
  for i in "${dotfiles_to_symlink[@]}"; do
    base_item_name=$(basename "$i")
    echo "Linking $i to $HOME/$base_item_name"
    rm -rf "$HOME/$base_item_name"
    ln -sf "$i" "$HOME/$base_item_name"
  done
fi

# ---- secrets ---------------------------
confirm "Do you want to link secrets?" do_secrets
if $do_secrets; then
  find "$HOME/pers/secrets" -type f -exec ansible-vault decrypt --vault-password-file "$HOME/pers/password" -- {} \;
  mv "$HOME/.ssh" "$HOME/.ssh.backup" 2>/dev/null || true
  ln -sf "$HOME/pers/secrets/ssh" "$HOME/.ssh"
fi

confirm "Do you set link keepassxc.ini?" do_keepass
if $do_keepass; then
  mkdir -p "$HOME/pers/dotfiles/.config/keepassxc"
  ln -sf "$HOME/pers/secrets/passwords/keepassxc.ini" "$HOME/pers/dotfiles/.config/keepassxc/keepassxc.ini"
fi

# ---- networking ---------------------------
confirm "Do you want to tweak networking settings?" do_networking
if $do_networking; then
  if [[ "${AUTO_YES:-false}" == "true" ]]; then
    pretty_hostname="My Laptop"
    static_hostname="my-laptop"
  else
    read -rp "Enter pretty hostname: " pretty_hostname
    read -rp "Enter static hostname: " static_hostname
  fi
  sudo hostnamectl set-hostname --pretty "$pretty_hostname"
  sudo hostnamectl set-hostname --static "$static_hostname"
  sudo ln -sf "$HOME/pers/config/hosts" /etc/hosts
fi

# ---- personalization ---------------------------
confirm "Do you set default user image?" do_user_image
if $do_user_image; then
  default_user_image_path="$HOME/pers/xdg/Pictures/default/sun-with-face.png"
  magick "$default_user_image_path" -resize 512x512 -gravity center -extent 512x512 "$default_user_image_path"
  sudo busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User SetIconFile s "$default_user_image_path"
fi

confirm "Do you create desktop entry for sessionizer?" do_sessionizer
if $do_sessionizer; then
  APP_NAME=sessionizer
  APP_CMD="kitty -e $HOME/pers/scripts/sessionizer"
  APP_ICON="utilities-terminal"
  APP_COMMENT="Open Neovim session with directory picker"
  DESKTOP_FILE="$HOME/.local/share/applications/${APP_NAME// /_}.desktop"
  mkdir -p "$HOME/.local/share/applications"

  cat >"$DESKTOP_FILE" <<EOL
[Desktop Entry]
Type=Application
Name=$APP_NAME
Exec=$APP_CMD
Icon=$APP_ICON
Comment=$APP_COMMENT
Terminal=true
Categories=Utility;
EOL

  chmod +x "$DESKTOP_FILE"

  CUSTOM_KEYBINDING_1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/sessionizer/"
  CUSTOM_KEYBINDING_2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/new_sessionizer/"
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
    "['$CUSTOM_KEYBINDING_1', '$CUSTOM_KEYBINDING_2']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEYBINDING_1 name 'Sessionizer'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEYBINDING_1 command "$APP_CMD"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$CUSTOM_KEYBINDING_1 binding '<Super>f'
fi

