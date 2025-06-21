-- ~/nvim/lua/slydragonn/plugins/formatter.lua

return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { { "prettier", "--config-precedence", "prefer-file" } },
				typescript = { { "prettier", "--config-precedence", "prefer-file" } },
				javascriptreact = { { "prettier", "--config-precedence", "prefer-file" } },
				typescriptreact = { { "prettier", "--config-precedence", "prefer-file" } },
				css = { { "prettier", "--config-precedence", "prefer-file" } },
				scss = { { "prettier", "--config-precedence", "prefer-file" } },
				html = { { "prettier", "--config-precedence", "prefer-file" } },
				json = { { "prettier", "--config-precedence", "prefer-file" } },
				yaml = { { "prettier", "--config-precedence", "prefer-file" } },
				markdown = { { "prettier", "--config-precedence", "prefer-file" } },
				lua = { "stylua" },
				python = { "isort", "black" },
				-- Added Ruby, Go, and Rust
				ruby = { "rubocop -a" },
				go = { "gofmt" }, -- `gofmt` is the default Go formatter
				rust = { "rustfmt" }, -- `rustfmt` is the official Rust formatter
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>m", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
