-- ~/nvim/lua/slydragonn/plugins/mason.lua

-- Mason is a plugin manager for Neovim that helps install and manage LSP servers,
-- formatters, linters, and other development tools
return {
	"williamboman/mason.nvim", -- Main Mason plugin for managing external tools
	dependencies = {
		"williamboman/mason-lspconfig.nvim", -- Bridge between Mason and nvim-lspconfig
		"WhoIsSethDaniel/mason-tool-installer.nvim", -- Auto-installs tools on Neovim startup
	},
	config = function()
		-- Initialize Mason with default settings
		require("mason").setup()

		-- Configure mason-lspconfig to manage LSP servers
		require("mason-lspconfig").setup({
			automatic_installation = true, -- Auto-install LSP servers when you open files
			ensure_installed = {
				"jdtls",        -- Java Language Server (Eclipse JDT)
				"cssls",        -- CSS Language Server
				"eslint",       -- ESLint Language Server (JavaScript/TypeScript linting)
				"html",         -- HTML Language Server
				"jsonls",       -- JSON Language Server
				"pyright",      -- Python Language Server (static type checker)
				"tailwindcss",  -- Tailwind CSS Language Server
				"intelephense", -- PHP Language Server
				"sqlls",        -- SQL Language Server
				"ts_ls",        -- TypeScript Language Server (formerly tsserver)
				"stylelint_lsp", -- Stylelint Language Server (CSS/SCSS linting)
				"bashls",       -- Bash Language Server
				"dockerls",     -- Docker Language Server (Dockerfile support)
				"solargraph",   -- Ruby Language Server
			},
		})

		-- Configure mason-tool-installer to manage formatters and other tools
		require("mason-tool-installer").setup({
			ensure_installed = {
				"prettier",      -- Code formatter for JavaScript, TypeScript, CSS, HTML, JSON, etc.
				"stylua",        -- Lua code formatter
				"eslint_d",      -- ESLint daemon (faster than regular eslint)
				"php-cs-fixer",  -- PHP code style fixer and formatter
				"shfmt",         -- Shell script formatter (bash, mksh, POSIX shell)
        "black",
        "isort"
			},
		})
	end,
}
