return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()

		-- Setup mason first
		require("mason").setup()
		require("mason-lspconfig").setup()

		-- local lspconfig = require('lspconfig')
		local protocol = require("vim.lsp.protocol")

    vim.lsp.enable({
        "cssls", -- npm i -g vscode-langservers-extracted
        "gopls", -- os package mgr: gopls
        "html",
        "jsonls",
        "lua_ls", -- os package mgr: lua-language-server
        "pyright", -- npm i -g pyright
        "ts_ls", -- npm i -g typescript typescript-language-server
    })
  end,
}


-- TODO: reenable them
		-- local servers_by_filetype = {
		-- 	-- CSS
		-- 	css = "cssls",
		-- 	scss = "cssls",
		-- 	less = "cssls",
		--
		-- 	-- Web
		-- 	html = "html",
		-- 	javascript = { "eslint", "ts_ls" },
		-- 	typescript = { "eslint", "ts_ls" },
		-- 	javascriptreact = { "eslint", "ts_ls" },
		-- 	typescriptreact = { "eslint", "ts_ls" },
		-- 	svelte = { "eslint", "ts_ls" },
		-- 	vue = { "eslint", "ts_ls" },
		--
		-- 	-- JSON
		-- 	json = "jsonls",
		-- 	jsonc = "jsonls",
		--
		-- 	-- Tailwind
		-- 	["html.twig"] = "tailwindcss",
		--
		-- 	-- Python
		-- 	python = "pyright",
		--
		-- 	-- Ruby
		-- 	ruby = "ruby_lsp",
		--
		-- 	-- PHP
		-- 	php = "intelephense",
		--
		-- 	-- Go
		-- 	go = "gopls",
		--
		-- 	-- Java
		-- 	-- java = "jdtls",
		--
		-- 	-- SQL
		-- 	sql = "sqlls",
		-- }
