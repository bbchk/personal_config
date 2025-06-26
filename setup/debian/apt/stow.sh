#!/usr/bin/env bash

SOURCE="$HOME/pers/setup/debian/apt"
TARGET='/etc/apt'

SOURCES=($(find $SOURCE -mindepth 1 -type d))
DIRS_TO_DELETE=()

for path in "${SOURCES[@]}"; do
  DIRS_TO_DELETE+=("$TARGET/$(basename "$path")")
done

sudo mv "$TARGET/sources.list" "$TARGET/sources.list.orig" || true
sudo mv "$TARGET/sources.list.d" "$TARGET/sources.list.d.orig" || true
# _ rm -rf "$DIRS_TO_DELETE" || true

# echo "$DIRS_TO_DELETE"
# echo "================="
# echo "${DIRS_TO_DELETE[@]}"

cd "$SOURCE"
sudo stow --target="$TARGET" .
