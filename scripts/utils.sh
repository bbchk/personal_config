#!/usr/bin/env bash

# ===========================
log () {
    if [[ -n "${DEBUG:-}" ]]; then
        echo "[DEBUG] $*"
    fi
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

is_installed() {
    rpm -q "$1" >/dev/null 2>&1
}
