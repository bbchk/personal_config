#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

log "Decrypting secrets..."
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions..."
find "/root/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers..."
cp "/root/pers/dotfiles/.custom/sys" /etc/sudoers.d/sudoers
chmod 440 /etc/sudoers.d/sudoers
