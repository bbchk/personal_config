#!/usr/bin/env bash

# ===========================
log () {
    if [[ -n "${DEBUG:-}" ]]; then
        echo "[DEBUG] $*"
    fi
}

confirm() {
  local prompt="$1"
  local __resultvar=$2
  local reply

  if [[ "${AUTO_YES:-false}" == "true" ]]; then
    reply="y"
    echo "$prompt (auto-yes)"
  else
    read -rp "$prompt (y/n): " reply
  fi

  if [[ "$reply" =~ ^[Yy]$ ]]; then
    eval "$__resultvar=true"
  else
    eval "$__resultvar=false"
  fi
}
