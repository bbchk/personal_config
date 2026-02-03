#!/usr/bin/env bash

# It's recommended to source utils.sh to make the confirm function available
source "$HOME/pers/setup/utils.sh"

set -euo pipefail

# ====================================

confirm "Do you want to apply all custom GNOME settings (workspaces, keybindings, etc.)?" apply_gnome_settings
if $apply_gnome_settings; then
  echo "Applying GNOME settings..."

  # ---- Workspaces below -------------------------------
  gsettings set org.gnome.mutter dynamic-workspaces false
  gsettings set org.gnome.desktop.wm.preferences num-workspaces "10"
  gsettings set org.gnome.desktop.wm.preferences workspace-names "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']"

  for i in {1..9}; do
    gsettings set org.gnome.shell.keybindings "switch-to-application-$i" "[]"
  done

  for i in {1..9}; do
    gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
    gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Shift><Super>$i']"
  done
  gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-10" "['<Super>0']"
  gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-10" "['<Shift><Super>0']"

  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Shift>h']"
  gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super><Shift>l']"

  gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
  # we need to unset super l first
  gsettings set org.gnome.desktop.wm.keybindings cycle-windows "['<Super>l']"
  gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "['<Super>h']"

  # ---- Windows below -------------------------------
  gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"
  gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
  gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

  # ---- Utlis below -------------------------------
  gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ua')]"
  gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>p']"
  gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "[]"
  gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/kitty

  # ---- Wellbeing below -------------------------------
  gsettings set org.gnome.desktop.screen-time-limits daily-limit-enabled "true"
  gsettings set org.gnome.desktop.screen-time-limits daily-limit-seconds "uint32 28800"
  gsettings set org.gnome.desktop.screen-time-limits grayscale "false"
  gsettings set org.gnome.desktop.screen-time-limits history-enabled "true"

  gsettings set org.gnome.desktop.break-reminders selected-breaks "['eyesight']"
  gsettings set org.gnome.desktop.break-reminders.eyesight countdown "false"
  gsettings set org.gnome.desktop.break-reminders.eyesight delay-seconds "uint32 180"
  gsettings set org.gnome.desktop.break-reminders.eyesight duration-seconds "uint32 20"
  gsettings set org.gnome.desktop.break-reminders.eyesight fade-screen "true"
  gsettings set org.gnome.desktop.break-reminders.eyesight interval-seconds "uint32 1200"
  gsettings set org.gnome.desktop.break-reminders.eyesight lock-screen "false"
  gsettings set org.gnome.desktop.break-reminders.eyesight notify "true"
  gsettings set org.gnome.desktop.break-reminders.eyesight notify-overdue "true"
  gsettings set org.gnome.desktop.break-reminders.eyesight notify-upcoming "false"
  gsettings set org.gnome.desktop.break-reminders.eyesight play-sound "false"
  echo "GNOME settings applied."
else
  echo "Skipping GNOME settings configuration."
fi


# ---- Extensions below -------------------------------

confirm "Do you want to install GNOME extensions?" do_install_extensions
if $do_install_extensions; then
  echo "Installing GNOME extensions..."
  flatpak install flathub org.gnome.Extensions

  gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com

  extensions=(
    "https://extensions.gnome.org/extension-data/just-perfection-desktopjust-perfection.v35.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/instantworkspaceswitcheramalantony.net.v10.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/VitalsCoreCoding.com.v73.shell-extension.zip"
    "https://extensions.gnome.org/extension-data/bluetooth-quick-connectbjarosze.gmail.com.v53.shell-extension.zip"
  )

  # Loop through each URL
  for url in "${extensions[@]}"; do
    filename=$(basename "$url")
    echo "Installing $filename..."
    wget -P /tmp "$url"
    gnome-extensions install --force "/tmp/$filename"
    rm "/tmp/$filename"
  done
  echo "GNOME extensions installed."
else
  echo "Skipping GNOME extensions installation."
fi



# TODO:
# gsettings set org.gnome.shell.extensions.pop-shell activate-launcher "[]"
# gsettings set org.gnome.shell.extensions.pop-shell focus-down "[]"
# gsettings set org.gnome.shell.extensions.pop-shell focus-left "[]"
# gsettings set org.gnome.shell.extensions.pop-shell focus-right "[]"
# gsettings set org.gnome.shell.extensions.pop-shell focus-up "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-down "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-left "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-right "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-monitor-up "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-down "[]"
# gsettings set org.gnome.shell.extensions.pop-shell pop-workspace-up "[]"
# gsettings set org.gnome.shell.extensions.pop-shell tile-enter "[]"
# gsettings set org.gnome.shell.extensions.pop-shell tile-orientation "[]"
# gsettings set org.gnome.shell.extensions.pop-shell toggle-floating "[]"
# gsettings set org.gnome.shell.extensions.pop-shell toggle-stacking-global "[]"
# gsettings set org.gnome.shell.extensions.pop-shell toggle-tiling "[]"
