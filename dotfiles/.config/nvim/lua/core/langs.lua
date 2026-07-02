-- Language scoping for LSP / tools / formatters / treesitter parsers.
--
-- The personas are split by toolchain (Rust-only, Go-only, ...), so installing
-- the full tooling set everywhere means mason tries to install servers/tools for
-- languages that aren't present and errors out on first launch. Here we detect
-- which toolchains actually exist (vim.fn.executable) and only enable/install the
-- matching tooling. Same env idiom as core/clipboard.lua / editor__lualine.lua.
--
-- Override with DEVCON_NVIM_LANGS="rust,lua" to force the set when detection is
-- wrong (e.g. a toolchain installed somewhere off PATH at startup).
--
-- Note: many servers/tools ship as npm packages (bashls, jsonls, dockerls, sqlls,
-- prettier, eslint_d, markdownlint, pyright, intelephense, php-*), so mason needs
-- `node` present to install them — that's why they live under the `node` gate (or
-- under a language whose personas always ship node), not in the always-on BASE.

local M = {}

-- Each language: `has` = detection binaries (any present => enabled); the rest is
-- what it contributes. `servers` feed both mason-lspconfig install and lsp.enable;
-- `tools` are mason-tool-installer packages; `parsers` are treesitter parsers;
-- `ft` maps filetype -> conform formatters.
local LANGS = {
	node = {
		has = { "node" },
		-- ts_ls..stylelint_lsp are node dev servers; bashls/jsonls/dockerls/sqlls
		-- are general but ship as npm packages, so they need node to install.
		servers = {
			"ts_ls",
			"eslint",
			"html",
			"cssls",
			"jsonls",
			"tailwindcss",
			"stylelint_lsp",
			"bashls",
			"dockerls",
			"sqlls",
		},
		tools = { "prettier", "eslint_d", "js-debug-adapter", "markdownlint" },
		parsers = { "javascript", "typescript", "tsx", "html", "css" },
		ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			javascriptreact = { "prettier" },
			typescriptreact = { "prettier" },
			css = { "prettier" },
			scss = { "prettier" },
			html = { "prettier" },
			json = { "prettier" },
			yaml = { "prettier" },
			markdown = { "prettier" },
		},
	},
	python = {
		has = { "python3", "python" },
		servers = { "pyright" }, -- pyright is npm; python personas ship node too
		tools = { "black", "isort" },
		parsers = { "python" },
		ft = { python = { "isort", "black" } },
	},
	go = {
		has = { "go" },
		servers = { "gopls" }, -- mason installs via `go install`, needs the go toolchain
		parsers = { "go" },
		ft = { go = { "gofmt" } },
	},
	rust = {
		has = { "cargo", "rustc" },
		servers = {}, -- rust-analyzer comes via rustup, not mason (matches prior config)
		parsers = { "rust" },
		ft = { rust = { "rustfmt" } },
	},
	ruby = {
		has = { "ruby" },
		servers = { "ruby_lsp" },
		tools = { "rubocop" },
		parsers = { "ruby" },
		ft = { ruby = { "rubocop" } },
	},
	php = {
		has = { "php" },
		servers = { "intelephense" }, -- npm; php personas ship node too
		tools = { "php-cs-fixer", "php-debug-adapter" },
		parsers = { "php" },
	},
	java = {
		has = { "java" },
		servers = { "jdtls" },
	},
	cpp = {
		has = { "clangd", "cc", "gcc", "clang" },
		servers = { "clangd" }, -- prebuilt binary, no toolchain needed to install
		tools = { "clang-format" },
		parsers = { "c", "cpp" },
	},
}

-- Always safe to install regardless of toolchain: prebuilt-binary servers/tools
-- and treesitter parsers (parsers only need a C compiler, always present).
local BASE = {
	servers = { "lua_ls" },
	tools = { "stylua", "shfmt" },
	parsers = {
		"vimdoc",
		"query",
		"lua",
		"vim",
		"bash",
		"json",
		"yaml",
		"markdown",
		"markdown_inline",
		"dockerfile",
		"gitignore",
	},
	ft = { lua = { "stylua" } },
}

local function present(bins)
	for _, b in ipairs(bins or {}) do
		if vim.fn.executable(b) == 1 then
			return true
		end
	end
	return false
end

-- Enabled language specs, computed once per session.
local _enabled
local function enabled()
	if _enabled then
		return _enabled
	end
	local override = vim.env.DEVCON_NVIM_LANGS
	local out = {}
	for name, spec in pairs(LANGS) do
		local on
		if override and override ~= "" then
			on = ("," .. override .. ","):find("," .. name .. ",", 1, true) ~= nil
		else
			on = present(spec.has)
		end
		if on then
			out[#out + 1] = spec
		end
	end
	_enabled = out
	return out
end

-- Merge a list-valued field across BASE + every enabled lang, deduped, stable order.
local function collect(field)
	local seen, out = {}, {}
	local function add(list)
		for _, v in ipairs(list or {}) do
			if not seen[v] then
				seen[v] = true
				out[#out + 1] = v
			end
		end
	end
	add(BASE[field])
	for _, spec in ipairs(enabled()) do
		add(spec[field])
	end
	return out
end

function M.servers()
	return collect("servers")
end

function M.mason_tools()
	return collect("tools")
end

function M.parsers()
	return collect("parsers")
end

function M.formatters_by_ft()
	local out = {}
	local function merge(ft)
		for k, v in pairs(ft or {}) do
			out[k] = v
		end
	end
	merge(BASE.ft)
	for _, spec in ipairs(enabled()) do
		merge(spec.ft)
	end
	return out
end

return M
