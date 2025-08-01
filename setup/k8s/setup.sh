#!/usr/bin/env bash

su

apt update
apt install sudo vim
sudo update-alternatives --config editor

sudo systemctl mask  "dev-*.swap"

