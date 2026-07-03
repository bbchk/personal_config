#!/usr/bin/env bash
# shellcheck source=/dev/null
#
# langtools: install editor tooling (LSP servers, formatters, linters, DAP
# adapters) into the image, gated on which language toolchains are present.
# This replaces nvim's mason -- nvim now just enables whatever is on PATH.
#
# Runs at image build as root (installsAfter the language features). Everything
# lands on the system PATH (/usr/local/bin, npm -g prefix, GOBIN), so it is NOT
# masked by the devcon-nvim-data volume the way ~/.local/share/nvim/mason was.
#
# Keep the language map here in sync with
# dotfiles/.config/nvim/lua/core/langs.lua: that file decides what nvim
# *enables*; this file decides what gets *installed*.

source /usr/local/share/devcontainer-helpers/utils.sh

ARCH="$(dpkg --print-architecture)" # amd64 | arm64
BIN=/usr/local/bin

# --- helpers ----------------------------------------------------------------
gh_latest() { # gh_latest owner/repo -> latest release tag (e.g. v0.20.0)
	curl -fsSL "https://api.github.com/repos/$1/releases/latest" | jq -r '.tag_name'
}

fetch() { # fetch URL DEST
	log "  download $1"
	curl -fsSL --retry 3 -o "$2" "$1"
}

npm_g() { # npm_g pkg...
	command_exists npm || {
		log "npm absent, skipping: $*"
		return 0
	}
	log "npm -g install: $*"
	npm install -g --no-fund --no-audit "$@"
}

pip_sys() { # pip_sys pkg...
	command_exists pip3 || command_exists pip || {
		log "pip absent, skipping: $*"
		return 0
	}
	log "pip install (system): $*"
	pip3 install --no-cache-dir --break-system-packages "$@" ||
		pip3 install --no-cache-dir "$@"
}

# --- BASE (always) ----------------------------------------------------------
log "base: lua-language-server, stylua, shfmt"

LLS_TAG="$(gh_latest LuaLS/lua-language-server)"
fetch "https://github.com/LuaLS/lua-language-server/releases/download/${LLS_TAG}/lua-language-server-${LLS_TAG}-linux-x64.tar.gz" /tmp/lls.tgz
mkdir -p /opt/lua-language-server
tar -xzf /tmp/lls.tgz -C /opt/lua-language-server
ln -sf /opt/lua-language-server/bin/lua-language-server "$BIN/lua-language-server"

STYLUA_TAG="$(gh_latest JohnnyMorganz/StyLua)"
fetch "https://github.com/JohnnyMorganz/StyLua/releases/download/${STYLUA_TAG}/stylua-linux-x86_64.zip" /tmp/stylua.zip
bsdtar -xf /tmp/stylua.zip -C "$BIN" stylua && chmod +x "$BIN/stylua"

SHFMT_TAG="$(gh_latest mvdan/sh)"
fetch "https://github.com/mvdan/sh/releases/download/${SHFMT_TAG}/shfmt_${SHFMT_TAG}_linux_${ARCH}" "$BIN/shfmt"
chmod +x "$BIN/shfmt"

# --- node / web -------------------------------------------------------------
if command_exists node; then
	log "node toolchain -> web language servers + formatters + js debug adapter"
	npm_g \
		typescript typescript-language-server \
		vscode-langservers-extracted \
		@tailwindcss/language-server \
		stylelint stylelint-lsp \
		bash-language-server \
		dockerfile-language-server-nodejs \
		sql-language-server \
		prettier eslint_d markdownlint-cli

	# js-debug-adapter (nvim-dap): install the server, expose a launcher on PATH.
	JSD_TAG="$(gh_latest microsoft/vscode-js-debug)"
	fetch "https://github.com/microsoft/vscode-js-debug/releases/download/${JSD_TAG}/js-debug-dap-${JSD_TAG}.tar.gz" /tmp/jsdbg.tgz
	mkdir -p /opt/js-debug
	tar -xzf /tmp/jsdbg.tgz -C /opt/js-debug --strip-components=1
	cat >"$BIN/js-debug-adapter" <<'EOF'
#!/usr/bin/env bash
exec node /opt/js-debug/src/dapDebugServer.js "$@"
EOF
	chmod +x "$BIN/js-debug-adapter"
fi

# --- python -----------------------------------------------------------------
if command_exists python3; then
	log "python toolchain -> pyright, black, isort"
	pip_sys black isort
	if command_exists npm; then
		npm_g pyright
	else
		pip_sys pyright
	fi
fi

# --- go ---------------------------------------------------------------------
if command_exists go; then
	log "go toolchain -> gopls"
	GOBIN="$BIN" GOFLAGS=-mod=mod go install golang.org/x/tools/gopls@latest
fi

# --- rust -------------------------------------------------------------------
# rustup is a per-user version manager; adding the component here only sticks if
# rustup is on PATH at build. The rust feature installs it system-wide, so this
# works, but the proxy binary resolves via CARGO_HOME -- verify on first build.
if command_exists rustup; then
	log "rust toolchain -> rust-analyzer (rustup component)"
	rustup component add rust-analyzer || log "WARN: rust-analyzer component add failed"
elif command_exists cargo; then
	log "WARN: cargo present but no rustup; rust-analyzer not installed"
fi

# --- ruby -------------------------------------------------------------------
# Same caveat as rust: rbenv is per-user. gem-installed bins must land on the
# runtime user's PATH; if the ruby feature uses rbenv, confirm the shim dir.
if command_exists gem; then
	log "ruby toolchain -> ruby-lsp, rubocop"
	gem install --no-document ruby-lsp rubocop || log "WARN: gem install failed (rbenv shim?)"
fi

# --- php --------------------------------------------------------------------
if command_exists php; then
	log "php toolchain -> intelephense, php-cs-fixer, php debug adapter"
	npm_g intelephense
	fetch "https://cs.symfony.com/download/php-cs-fixer-v3.phar" "$BIN/php-cs-fixer"
	chmod +x "$BIN/php-cs-fixer"

	PHPD_TAG="$(gh_latest xdebug/vscode-php-debug)"
	fetch "https://github.com/xdebug/vscode-php-debug/releases/download/${PHPD_TAG}/php-debug-${PHPD_TAG#v}.vsix" /tmp/phpdbg.vsix
	mkdir -p /opt/php-debug
	bsdtar -xf /tmp/phpdbg.vsix -C /opt/php-debug
	cat >"$BIN/php-debug-adapter" <<'EOF'
#!/usr/bin/env bash
exec node /opt/php-debug/extension/out/phpDebug.js "$@"
EOF
	chmod +x "$BIN/php-debug-adapter"
fi

# --- c / c++ ----------------------------------------------------------------
if command_exists cc || command_exists gcc || command_exists clang; then
	log "c/c++ toolchain -> clangd, clang-format"
	apt-get update && apt-get install -y clangd clang-format
fi

# --- java -------------------------------------------------------------------
# jdtls (eclipse.jdt.ls) is heavy and stateful; left as a follow-up. To add it:
# download the milestone tarball to /opt/jdtls and wrap a launcher on PATH here.

log "langtools install complete"
