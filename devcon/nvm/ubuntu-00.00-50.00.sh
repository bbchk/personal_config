#!/usr/bin/env bash

source /usr/local/share/devcontainer-helpers/utils.sh

log "Starting Ubuntu install.sh execution..."

log "Installing critical base packages first..."
apt install -y sudo curl git make

log "Installing NVM..."
export NVM_DIR="/usr/local/nvm"
mkdir -p "$NVM_DIR"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | NVM_DIR="$NVM_DIR" bash

# Load nvm for the rest of this script
source "$NVM_DIR/nvm.sh"

log "Installing Node.js LTS via NVM..."
nvm install --lts
nvm alias default node
nvm use default

log "Making node/npm globally accessible for non-interactive shells (Mason, scripts, etc.)..."
NODE_BIN_DIR="$(dirname "$(nvm which current)")"
ln -sf "$NODE_BIN_DIR/node" /usr/local/bin/node
ln -sf "$NODE_BIN_DIR/npm" /usr/local/bin/npm
ln -sf "$NODE_BIN_DIR/npx" /usr/local/bin/npx

log "Setting up NVM in /etc/profile.d so all shells can use it..."
cat > /etc/profile.d/nvm.sh << 'EOF'
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
EOF
chmod +x /etc/profile.d/nvm.sh

log "Verifying node/npm..."
node --version
npm --version
