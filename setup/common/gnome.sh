#!/usr/bin/env bash

# It's recommended to source utils.sh to make the confirm function available
source "$HOME/pers/setup/common/utils.sh"

# ====================================

SCHEMAS=(
    "org.gnome.desktop.wm.keybindings"
    "org.gnome.settings-daemon.plugins.media-keys"
    "org.gnome.shell.keybindings"
    "org.gnome.mutter.keybindings"
    "org.gnome.mutter.wayland.keybindings"
    "org.freedesktop.ibus.general"
    "org.freedesktop.ibus.panel.emoji"
)

for SCHEMA in "${SCHEMAS[@]}"; do
    KEYS=$(gsettings list-keys "$SCHEMA" 2>/dev/null)
    for KEY in $KEYS; do
        # Most GNOME keys are arrays ['<Key>']
        # We try to set them to an empty array
        gsettings set "$SCHEMA" "$KEY" "['']" 2>/dev/null
    done
done

gsettings set org.gnome.mutter overlay-key 'Super_L'

gsettings set org.gnome.settings-daemon.plugins.media-keys volume-down "['XF86AudioLowerVolume']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-up "['XF86AudioRaiseVolume']"
gsettings set org.gnome.settings-daemon.plugins.media-keys volume-mute "['XF86AudioMute']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-down "['XF86MonBrightnessDown']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screen-brightness-up "['XF86MonBrightnessUp']"

log "Configuring workspace behavior: setting 10 static workspaces and dark mode preference."
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.desktop.wm.preferences num-workspaces "10"
gsettings set org.gnome.desktop.wm.preferences workspace-names "['1', '2', '3', '4', '5', '6', '7', '8', '9', '10']"
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

log "Mapping Super+1-0 to workspaces and unbinding default application shortcuts."
for i in {1..9}; do
  gsettings set org.gnome.shell.keybindings "switch-to-application-$i" "[]"
done

for i in {1..9}; do
  gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$i" "['<Super>$i']"
  gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$i" "['<Shift><Super>$i']"
done

gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-10" "['<Super>0']"
gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-10" "['<Shift><Super>0']"

log "Configuring Vim-style (H/L) navigation for workspace switching and window cycling."
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-left "['<Super><Shift>h']"
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-right "['<Super><Shift>l']"

gsettings set org.gnome.desktop.wm.keybindings minimize "[]" # We need to unset super l first to avoid collision with workspace logic
gsettings set org.gnome.desktop.wm.keybindings cycle-windows "['<Super>l']"
gsettings set org.gnome.desktop.wm.keybindings cycle-windows-backward "['<Super>h']"

log "Customizing window management: setting Super+Q to close and Super+M to maximize."
gsettings set org.gnome.shell.keybindings toggle-message-tray "[]"
gsettings set org.gnome.desktop.wm.keybindings toggle-maximized "['<Super>m']"
gsettings set org.gnome.desktop.wm.keybindings close "['<Super>q']"

log "Setting system utilities: configuring US/UA keyboard layouts, Kitty terminal, and screenshots."
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'ua')]"
gsettings set org.gnome.shell.keybindings show-screenshot-ui "['<Super>p']"
gsettings set org.gnome.settings-daemon.plugins.media-keys screensaver "[]"
gsettings set org.gnome.desktop.default-applications.terminal exec /usr/bin/kitty

log "Enabling wellbeing features: daily screen time limits and eyesight break reminders."
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

log "Installing and enabling GNOME Shell extensions for workflow enhancement."
flatpak install flathub org.gnome.Extensions
gnome-extensions enable launch-new-instance@gnome-shell-extensions.gcampax.github.com

extensions=(
  "https://extensions.gnome.org/extension-data/just-perfection-desktopjust-perfection.v35.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/instantworkspaceswitcheramalantony.net.v10.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/VitalsCoreCoding.com.v73.shell-extension.zip"
  "https://extensions.gnome.org/extension-data/bluetooth-quick-connectbjarosze.gmail.com.v53.shell-extension.zip"
)

for url in "${extensions[@]}"; do
  filename=$(basename "$url")
  log "Downloading and installing extension: $filename"
  wget -P /tmp "$url"
  gnome-extensions install --force "/tmp/$filename"
  rm "/tmp/$filename"
done

log "Registering custom global shortcuts for Sessionizer and Flameshot."
K1="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
K2="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"

gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['$K1', '$K2']"

log "Binding Super+F to Sessionizer and Super+O to Flameshot."
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 name 'Sessionizer'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 command "kitty -e $HOME/pers/scripts/sessionizer"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K1 binding '<Super>f'

gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 name 'Flameshot'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 command "$HOME/pers/scripts/flameshot.sh --raw | wl-copy"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:$K2 binding '<Super>o'

log "Creating desktop entry to autostart Neovim Sessionizer on login."
mkdir -p ~/.config/autostart
cat > ~/.config/autostart/nvim-sessionizer.desktop << EOF
[Desktop Entry]
Type=Application
Name=Neovim Sessionizer
Exec=gnome-terminal -- nvim -c "lua require('custom.sessionizer').sessionizer()"
Icon=utilities-terminal
Comment=Starts Neovim with the sessionizer plugin
EOF
