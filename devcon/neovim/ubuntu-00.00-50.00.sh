#!/usr/bin/env bash
# shellcheck source=/dev/null

source /usr/local/share/devcontainer-helpers/utils.sh

apt-get update && apt-get install -y \
  git \
  build-essential \
  wget \
  curl \
  python3 \
  python3-pip \
  python-is-python3 \
  ripgrep \
  unzip \
  fzf \
  zsh \
  iproute2

ARCHIVE="nvim-linux-x86_64.tar.gz"
TEMP_DIR=$(mktemp -d)
SRC="$TEMP_DIR/nvim-linux-x86_64"

wget -P "$TEMP_DIR" "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/$ARCHIVE"
tar -xf "$TEMP_DIR/$ARCHIVE" -C "$TEMP_DIR"

mv -f "$SRC/bin/nvim" /usr/local/bin/
ln -sf /usr/local/bin/nvim /usr/bin/nvim
cp -ru "$SRC/share/." /usr/local/share/
cp -ru "$SRC/lib/." /usr/local/lib/
[ -d "$SRC/man" ] && cp -ru "$SRC/man/." /usr/local/man/

rm -rf "$TEMP_DIR"

# Pre-install plugins and treesitter parsers at build time
nvim --headless "+Lazy! sync" +qa 2>/dev/null || true
nvim --headless "+TSInstall! all" +qa 2>/dev/null || true

# Clean up any stale tmp dirs left by failed parser compilations
find "${XDG_DATA_HOME:-$HOME/.local/share}/nvim" \
  -name "*-tmp" -type d -exec rm -rf {} + 2>/dev/null || true
