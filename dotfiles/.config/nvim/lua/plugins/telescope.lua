return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").setup({
			defaults = {
				file_ignore_patterns = { "node_modules/" },
				hidden = true,
			},
			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})

		local keymap = vim.keymap

		keymap.set(
			"n",
			"<leader>f",
			"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
			{ desc = "Find files including hidden, excluding .git" }
		)

		keymap.set(
			"n",
			"<leader>_",
			"<cmd>lua require'telescope.builtin'.live_grep()<cr>",
			{ desc = "Fuzzy find recent files" }
		)

		keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find string in cwd" })

		keymap.set("n", "<leader>f?", "<cmd>Telescope git commits<cr>", { desc = "Find todos" })

		keymap.set(
			"n",
			"<leader>fs",
			"<cmd>lua require'telescope.builtin'.git_status()<cr>",
			{ desc = "Show git status" }
		)

		-- keymap.set("n", "<leader>/", ":silent grep ", { desc = "Find todos" })
	end,
}
