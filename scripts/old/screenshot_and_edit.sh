#!/bin/bash

# This script helps automate copying a drawing and closing the window on Wayland.
# It requires 'gnome-screenshot' (usually pre-installed) and 'ydotool'.
#
# DEPENDENCY: Install ydotool with:
# sudo apt update && sudo apt install ydotool
#
# IMPORTANT SETUP for ydotool:
# For ydotool to work, its service must be running. You may need to run:
# sudo systemctl enable --now ydotool.service
# You also need to add your user to the 'input' group:
# sudo usermod -aG input $USER
# After this, you MUST log out and log back in for the group change to take effect.

# Check if ydotool is available
if ! command -v ydotool &> /dev/null
then
    echo "Error: ydotool is not installed or not in your PATH."
    echo "Please install it using: sudo apt install ydotool"
    echo "And follow the one-time setup steps described in the script comments."
    exit 1
fi

echo "Ready to capture. Please select the area of your drawing."
echo "The active window will be closed after the capture."

# 1. Launch the interactive screenshot tool to select an area and copy it.
# The script will pause here until you finish the selection.
gnome-screenshot -ac

# Check if the screenshot was cancelled (exit code 1)
if [ $? -ne 0 ]; then
    echo "Screenshot cancelled. Nothing was closed."
    exit 0
fi

# 2. Give a brief moment for the focus to be settled.
sleep 0.5

# 3. Simulate pressing Ctrl+W to close the active window.
# This is safer than Ctrl+Q, as it often just closes a tab/document.
# key 29:1 -> Ctrl down
# key 17:1 -> W down
# key 17:0 -> W up
# key 29:0 -> Ctrl up
ydotool key 29:1 17:1 17:0 29:0

echo "Capture complete, and 'Close Window' command sent."
