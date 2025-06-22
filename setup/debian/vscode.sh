#!/usr/bin/env bash

# Simple Visual Studio Code Installation Script for Debian/Ubuntu
# This script installs VS Code using Microsoft's official repository

set -e  # Exit on any error

echo "Installing Visual Studio Code..."

# Update package list
echo "Updating package list..."
sudo apt update

# Install required dependencies
echo "Installing dependencies..."
sudo apt install -y wget gpg

# Download and install Microsoft GPG key
echo "Adding Microsoft GPG key..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# Clean up temporary file
rm -f packages.microsoft.gpg

# Update package list with new repository
echo "Updating package list..."
sudo apt update

# Install Visual Studio Code
echo "Installing Visual Studio Code..."
sudo apt install -y code

# Verify installation
if command -v code &> /dev/null; then
    echo "✅ Visual Studio Code installed successfully!"
    echo "Run 'code' to launch VS Code"
else
    echo "❌ Installation failed"
    exit 1
fi
