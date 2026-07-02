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
		-- mason + mason-lspconfig are configured with real options in lsp__mason.lua.

		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client:supports_method("textDocument/completion") then
					vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
				end
			end,
		})

		-- Enable only the servers scoped to this container's toolchains (same list
		-- that mason installs in lsp__mason.lua, so enable and install stay in sync).
		vim.lsp.enable(require("core.langs").servers())
	end,
}
