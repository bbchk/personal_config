#!/usr/bin/env bash

set -euo pipefail

gset() {
  local schema="$1"
  local key="$2"
  local value="$3"
  gsettings set "$schema" "$key" "$value"
}

# ====================================

# ---- Workspaces below -------------------------------

gset org.gnome.desktop.wm.preferences num-workspaces "10"
gset org.gnome.desktop.wm.preferences workspace-names "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']"

for i in {1..9}; do
  gset org.gnome.shell.keybindings "switch-to-application-$i" "[]"
done

for i in {1..10}; do
  gset org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
  gset org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Shift><Super>$i']"
done

# ---- Windows below -------------------------------

gset org.gnome.shell.keybindings toggle-message-tray "[]"
gset org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"

# ---- Utlis below -------------------------------

gset org.gnome.shell.keybindings show-screenshot-ui "['<Super>p']"

# ---- Wellbeing below -------------------------------

gset org.gnome.desktop.screen-time-limits daily-limit-enabled "true"
gset org.gnome.desktop.screen-time-limits daily-limit-seconds "uint32 28800"
gset org.gnome.desktop.screen-time-limits grayscale "true"
gset org.gnome.desktop.screen-time-limits history-enabled "true"

gset org.gnome.desktop.break-reminders selected-breaks "['eyesight']"
gset org.gnome.desktop.break-reminders.eyesight countdown "false"
gset org.gnome.desktop.break-reminders.eyesight delay-seconds "uint32 180"
gset org.gnome.desktop.break-reminders.eyesight duration-seconds "uint32 20"
gset org.gnome.desktop.break-reminders.eyesight fade-screen "true"
gset org.gnome.desktop.break-reminders.eyesight interval-seconds "uint32 1200"
gset org.gnome.desktop.break-reminders.eyesight lock-screen "false"
gset org.gnome.desktop.break-reminders.eyesight notify "true"
gset org.gnome.desktop.break-reminders.eyesight notify-overdue "true"
gset org.gnome.desktop.break-reminders.eyesight notify-upcoming "false"
gset org.gnome.desktop.break-reminders.eyesight play-sound "true"

# ---- Extensions below -------------------------------

# TODO: install all extensions programmatically
#wget https://extensions.gnome.org/extension-data/instantworkspaceswitcheramalantony.net.v10.shell-extension.zip
# gnome-extensions install <zip>
