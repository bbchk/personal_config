#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

log "Decrypting secrets..."
git -C "$HOME/pers" checkout -- .
# Here it requires passphrase which I don't rpovide, so it just fails and goes on

log "Fixing SSH key permissions..."
find "$TARGET_PATH/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers to /etc/sudoers.d/sudoers..."
CUSTOM_DIR="$DOTFILES_FULL/.custom/sys"
cp "$CUSTOM_DIR/sudoers" /etc/sudoers.d/sudoers
chmod 440 /etc/sudoers.d/sudoers
