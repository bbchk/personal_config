return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(ev)
				local client = vim.lsp.get_client_by_id(ev.data.client_id)
				if client:supports_method("textDocument/completion") then
					vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
				end
			end,
		})

		-- Enable the servers scoped to this container's toolchains. The binaries
		-- themselves are installed into the image by the langtools devcontainer
		-- feature; vim.lsp.enable only launches a server when its filetype opens
		-- and its cmd is on PATH, so an absent toolchain is a no-op.
		vim.lsp.enable(require("core.langs").servers())
	end,
}
