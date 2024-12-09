# ------------------------------
# System specific 
# ------------------------------

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

if ! pgrep -x "keychain" > /dev/null; then
  for key in ~/.ssh/*; do
    [ -f "$key" ] && eval $(keychain --eval --agents ssh "$key" > /dev/null 2>&1)
  done
fi

# ------------------------------
# End system specific 
# ------------------------------
