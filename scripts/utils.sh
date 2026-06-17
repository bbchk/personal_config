#!/usr/bin/env bash

# ===========================
log() {
    echo "  → $*" >&2
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

is_installed() {
    if command_exists dpkg; then
        dpkg -s "$1" >/dev/null 2>&1
    elif command_exists rpm; then
        rpm -q "$1" >/dev/null 2>&1
    fi
}
