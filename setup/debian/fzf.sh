#!/usr/bin/env bash

set -euo pipefail

tmp_dir=$(mktemp -d)

git clone --depth 1 https://github.com/junegunn/fzf.git "$tmp_dir"

"$tmp_dir/install"
