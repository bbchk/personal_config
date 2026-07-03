-- Language scoping for nvim: which LSP servers to enable, which conform
-- formatters to run, and which treesitter parsers to expect -- scoped to the
-- toolchains actually present in this container.
--
-- We detect toolchains with vim.fn.executable and only enable matching tooling,
-- so a single-purpose container (rust-only, go-only, ...) never tries to start a
-- server or run a formatter whose binary isn't installed.
--
-- INSTALLATION lives in the image, not here. The `langtools` devcontainer
-- feature (devcon/langtools) installs the LSP servers, formatters and linters
-- onto the system PATH, and postCreate.sh compiles the treesitter parsers. nvim
-- just enables whatever ended up on PATH -- there is no mason. Keep the map
-- below in sync with what devcon/langtools installs.
--
-- Override detection with DEVCON_NVIM_LANGS="rust,lua" when it guesses wrong
-- (e.g. a toolchain installed off PATH at startup). Same env idiom as
-- core/clipboard.lua.

local M = {}

-- Each language: `has` = detection binaries (any present => enabled); `servers`
-- feed vim.lsp.enable, `parsers` feed treesitter, `ft` maps filetype -> conform
-- formatters.
local LANGS = {
	node = {
		has = { "node" },
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
		servers = { "pyright" },
		parsers = { "python" },
		ft = { python = { "isort", "black" } },
	},
	go = {
		has = { "go" },
		servers = { "gopls" },
		parsers = { "go" },
		ft = { go = { "gofmt" } },
	},
	rust = {
		has = { "cargo", "rustc" },
		-- rust-analyzer is installed as a rustup component by langtools, so it
		-- lands on PATH and we can enable it here (was previously unmanaged).
		servers = { "rust_analyzer" },
		parsers = { "rust" },
		ft = { rust = { "rustfmt" } },
	},
	ruby = {
		has = { "ruby" },
		servers = { "ruby_lsp" },
		parsers = { "ruby" },
		ft = { ruby = { "rubocop" } },
	},
	php = {
		has = { "php" },
		servers = { "intelephense" },
		parsers = { "php" },
	},
	java = {
		has = { "java" },
		servers = { "jdtls" },
	},
	cpp = {
		has = { "clangd", "cc", "gcc", "clang" },
		servers = { "clangd" },
		parsers = { "c", "cpp" },
	},
}

-- Always safe regardless of toolchain (prebuilt-binary servers, base parsers).
local BASE = {
	servers = { "lua_ls" },
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
