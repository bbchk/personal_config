#!/usr/bin/env bash

set -euo pipefail

# ====================================

sudo dnf update -y --skip-unavailable --exclude=openh264

./install.sh
./config.sh
