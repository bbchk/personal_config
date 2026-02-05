#!/usr/bin/env bash

source "$HOME/pers/setup/common/utils.sh"

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
  sudo ln -sf "$HOME/pers/secrets/hosts" /etc/hosts
fi

# ---- personalization ---------------------------
confirm "Do you set default user image?" do_user_image
if $do_user_image; then
  default_user_image_path="$HOME/pers/xdg/Pictures/default/sun-with-face.png"
  magick "$default_user_image_path" -resize 512x512 -gravity center -extent 512x512 "$default_user_image_path"
  sudo busctl call org.freedesktop.Accounts /org/freedesktop/Accounts/User$(id -u) org.freedesktop.Accounts.User SetIconFile s "$default_user_image_path"
fi

confirm "Do you create custom shorcuts" do_shortcuts
if $do_shortcuts; then
  # Define the paths
  K1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
  K2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
  K3="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"

  # Apply the list all at once - Notice the nested quoting
  gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$K1', '$K2', '$K3']"

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 name 'Sessionizer'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 command "kitty -e $HOME/pers/scripts/sessionizer"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 binding '<Super>f'

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 name 'Swappy'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 command "bash -c 'gnome-screenshot -f /tmp/screenshot.png && swappy -f /tmp/screenshot.png'"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 binding '<Super>o'

  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 name 'Flameshot'
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 command "$HOME/pers/scripts/flameshot.sh --raw | wl-copy"
  gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K3 binding '<Super>['
fi

confirm "Do you create nvim autostart" do_nvim_auto
if $do_nvim_auto; then

  mkdir -p ~/.config/autostart

  cat > ~/.config/autostart/nvim-sessionizer.desktop << EOF
[Desktop Entry]
Type=Application
Name=Neovim Sessionizer
Exec=gnome-terminal -- nvim -c "lua require('custom.sessionizer').sessionizer()"
Icon=utilities-terminal
Comment=Starts Neovim with the sessionizer plugin
EOF

fi
