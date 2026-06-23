#!/usr/bin/env bash

source /usr/local/share/devcontainer-helpers/utils.sh

apt-get update
apt-get install -y \
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
