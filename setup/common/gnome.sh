#!/usr/bin/env bash

set -euo pipefail

# ====================================

# ---- Workspaces below -------------------------------

gsettings org.gnome.desktop.wm.preferences num-workspaces "10"
gsettings org.gnome.desktop.wm.preferences workspace-names "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']"

for i in {1..9}; do
  gsettings org.gnome.shell.keybindings "switch-to-application-$i" "[]"
done

for i in {1..9}; do
  gsettings org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
  gsettings org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Shift><Super>$i']"
done

gsettings org.gnome.desktop.wm.keybindings "switch-to-workspace-10" "['<Super>0']"
gsettings org.gnome.desktop.wm.keybindings "move-to-workspace-10" "['<Shift><Super>0']"

# ---- Windows below -------------------------------

gsettings org.gnome.shell.keybindings toggle-message-tray "[]"
gsettings org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"

# ---- Utlis below -------------------------------

gsettings org.gnome.shell.keybindings show-screenshot-ui "['<Super>p']"
gsettings org.gnome.settings-daemon.plugins.media-keys screensaver "[]"

# ---- Wellbeing below -------------------------------

gsettings org.gnome.desktop.screen-time-limits daily-limit-enabled "true"
gsettings org.gnome.desktop.screen-time-limits daily-limit-seconds "uint32 28800"
gsettings org.gnome.desktop.screen-time-limits grayscale "false"
gsettings org.gnome.desktop.screen-time-limits history-enabled "true"

gsettings org.gnome.desktop.break-reminders selected-breaks "['eyesight']"
gsettings org.gnome.desktop.break-reminders.eyesight countdown "false"
gsettings org.gnome.desktop.break-reminders.eyesight delay-seconds "uint32 180"
gsettings org.gnome.desktop.break-reminders.eyesight duration-seconds "uint32 20"
gsettings org.gnome.desktop.break-reminders.eyesight fade-screen "true"
gsettings org.gnome.desktop.break-reminders.eyesight interval-seconds "uint32 1200"
gsettings org.gnome.desktop.break-reminders.eyesight lock-screen "false"
gsettings org.gnome.desktop.break-reminders.eyesight notify "true"
gsettings org.gnome.desktop.break-reminders.eyesight notify-overdue "true"
gsettings org.gnome.desktop.break-reminders.eyesight notify-upcoming "false"
gsettings org.gnome.desktop.break-reminders.eyesight play-sound "false"

# ---- Extensions below -------------------------------

read -rp "Do you want to install gnome extensions? (y/n)" extensions_y_n
case "$extensions_y_n" in
[Yy]*)
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

    wget -P /tmp "$url"
    gnome-extensions install --force "/tmp/$filename"
    rm "/tmp/$filename"
  done
  ;;
esac
