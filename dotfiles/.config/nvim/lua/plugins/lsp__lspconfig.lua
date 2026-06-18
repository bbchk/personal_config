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
		require("mason").setup()
		require("mason-lspconfig").setup()

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client:supports_method("textDocument/completion") then
					vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
				end
			end,
		})

		vim.lsp.enable({
			"cssls",
			"eslint",
			"gopls",
			"html",
			"intelephense",
			"jsonls",
			"lua_ls",
			"pyright",
			"ruby_lsp",
			"sqlls",
			"tailwindcss",
			"ts_ls",
			"clangd",
			"bashls",
			"dockerls",
			"stylelint_lsp",
		})
	end,
}
