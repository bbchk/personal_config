#!/usr/bin/env bash

set -e

NVIM_VERSION="$VERSION"

source /usr/local/share/devcontainer-helpers/utils.sh

source_matching_installer

apt_cleanup
