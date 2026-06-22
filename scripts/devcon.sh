#!/usr/bin/env bash

set -euo pipefail

source /usr/local/share/devcontainer-helpers/utils.sh

# log "Importing gpg keys"
# chmod 700 /root/.gnupg
# gpg --import /root/.gnupg/devcon-public.asc
# gpg --list-keys --with-colons \
#     | awk -F: '/^fpr/{print $10":6:"; exit}' \
#     | gpg --import-ownertrust

log "Decrypting secrets..."
git -C "$HOME/pers" checkout -- .

log "Fixing SSH key permissions..."
find "/root/pers/" -path '*/.ssh/*' -type f ! -name '*.pub' -exec chmod 600 {} + 2>/dev/null || true

log "Copying sudoers..."
cp "/root/pers/dotfiles/.custom/sys/sudoers" /etc/sudoers.d/sudoers
chmod 440 /etc/sudoers.d/sudoers
