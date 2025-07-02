#!/usr/bin/env bash

# Create a temporary directory
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Cleanup function
cleanup() {
    echo "Cleaning up temporary directory: $TEMP_DIR"
    rm -rf "$TEMP_DIR"
}

# Set trap to cleanup on exit
trap cleanup EXIT

# Clone and build
cd "$TEMP_DIR"
git clone git@github.com:sinclairtarget/git-who.git
cd git-who
rake
./git-who --version

# Install globally
sudo cp git-who /usr/local/bin/
#
echo "Installation complete!"
git-who --version
