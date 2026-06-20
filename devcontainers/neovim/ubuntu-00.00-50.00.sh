#!/usr/bin/env bash

apt update
apt install -y \
  git \
  build-essential \
  wget \
  curl \
  python3 \
  python3-pip \
  python-is-python3 \
  ripgrep \
  unzip \
  fzf

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

