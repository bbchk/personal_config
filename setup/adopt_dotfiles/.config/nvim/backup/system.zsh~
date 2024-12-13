# ------------------------------
# System specific 
# ------------------------------

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Start ssh-agent if not already running and add all SSH keys from ~/.ssh
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null

    # Add all SSH keys in ~/.ssh directory (excluding non-key files)
    for key in ~/.ssh/*; do
        if [ -f "$key" ] && [[ "$key" == ~/.ssh/id_* ]]; then
            ssh-add "$key" &>/dev/null
        fi
    done
else
    # Check if any keys are already added, and add missing ones
    for key in ~/.ssh/*; do
        if [ -f "$key" ] && [[ "$key" == ~/.ssh/id_* ]]; then
            ssh-add -l &>/dev/null || ssh-add "$key" &>/dev/null
        fi
    done
fi

# ------------------------------
# End system specific 
# ------------------------------
