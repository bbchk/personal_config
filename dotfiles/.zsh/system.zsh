# ------------------------------
# System specific 
# ------------------------------

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"


export XDG_DESKTOP_DIR="$HOME/pers/xdg/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_TEMPLATES_DIR="$HOME/pers/xdg/Templates"
export XDG_PUBLICSHARE_DIR="$HOME/pers/xdg/Public"
export XDG_DOCUMENTS_DIR="$HOME/pers/xdg/Documents"
export XDG_MUSIC_DIR="$HOME/pers/xdg/Music"
export XDG_PICTURES_DIR="$HOME/pers/xdg/Pictures"
export XDG_VIDEOS_DIR="$HOME/pers/xdg/Videos"

# if [ -z "$SSH_AUTH_SOCK" ]; then
#   eval `ssh-agent -s` > /dev/null;
# fi

# if ! pgrep -x "keychain" > /dev/null; then
#   for key in ~/.ssh/*; do
#     [ -f "$key" ] && eval $(keychain --eval --agents ssh "$key" > /dev/null 2>&1)
#   done
# fi

# ------------------------------
# End system specific 
# ------------------------------
