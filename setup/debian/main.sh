
# TODO:
# create ~/dev
# rename Downloads to downloads
#
#
#
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-1 "['<Super>1']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-2 "['<Super>2']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-3 "['<Super>3']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-4 "['<Super>4']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-5 "['<Super>5']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-6 "['<Super>6']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-7 "['<Super>7']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-8 "['<Super>8']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-9 "['<Super>9']"
# gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"
#
#gsettings set org.gnome.settings-daemon.plugins.media-keys home "[]"

gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-10 "['<Super>0']"

# Set the command
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ name 'Rofi Launcher'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ command 'rofi -show drun -normal-window'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ binding '<Super>d'

# Enable the custom keybinding
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
