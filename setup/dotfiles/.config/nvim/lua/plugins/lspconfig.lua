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

		local lspconfig = require("lspconfig")
		local protocol = require("vim.lsp.protocol")

		local on_attach = function(client, bufnr)
			-- format on save
			if client.server_capabilities.documentFormattingProvider then
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = vim.api.nvim_create_augroup("Format", { clear = true }),
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format()
					end,
				})
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		-- Map filetypes to their LSP servers
		local servers_by_filetype = {
			-- CSS
			css = "cssls",
			scss = "cssls",
			less = "cssls",

			-- Web
			html = "html",
			javascript = { "eslint", "ts_ls" },
			typescript = { "eslint", "ts_ls" },
			javascriptreact = { "eslint", "ts_ls" },
			typescriptreact = { "eslint", "ts_ls" },
			svelte = { "eslint", "ts_ls" },
			vue = { "eslint", "ts_ls" },

			-- JSON
			json = "jsonls",
			jsonc = "jsonls",

			-- Tailwind
			["html.twig"] = "tailwindcss",

			-- Python
			python = "pyright",

			-- Ruby
			ruby = "solargraph",

			-- PHP
			php = "intelephense",

			-- Go
			go = "gopls",

			-- Java
			java = "jdtls",

			-- SQL
			sql = "sqlls",
		}

		-- Create a lookup table to check if a server is already set up
		local server_setup_done = {}

		-- Create autocmd group for LSP setup
		local lsp_setup_group = vim.api.nvim_create_augroup("LspFiletypeSetup", { clear = true })

		-- Create a function to setup a server
		local setup_server = function(server_name)
			if server_setup_done[server_name] then
				return
			end

			server_setup_done[server_name] = true

			lspconfig[server_name].setup({
				on_attach = on_attach,
				capabilities = capabilities,
			})
		end

		-- Register auto commands for all the filetypes
		for ft, servers in pairs(servers_by_filetype) do
			vim.api.nvim_create_autocmd("FileType", {
				pattern = ft,
				group = lsp_setup_group,
				callback = function()
					-- Handle both string and table values
					if type(servers) == "string" then
						setup_server(servers)
					else
						for _, server in ipairs(servers) do
							setup_server(server)
						end
					end
				end,
			})
		end

		-- Set up any servers that might need special configuration
		-- or don't map directly to a filetype
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*",
			group = lsp_setup_group,
			callback = function()
				local ft = vim.bo.filetype

				-- Check for tailwind in any file that might use it
				if
					vim.fn.filereadable(".tailwindcss") == 1
					or vim.fn.filereadable("tailwind.config.js") == 1
					or vim.fn.filereadable("tailwind.config.cjs") == 1
				then
					setup_server("tailwindcss")
				end

				-- Add any other special case detection here
			end,
		})

		-- Handle any manual LSP server initialization requests
		vim.api.nvim_create_user_command("LspStart", function(opts)
			local server = opts.args
			if server and server ~= "" then
				setup_server(server)
			end
		end, {
			nargs = 1,
			complete = function()
				return vim.tbl_keys(lspconfig)
			end,
		})
	end,
}
