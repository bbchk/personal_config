return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.6",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("telescope").setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
					height = 0.95,
					width = 0.95,
					preview_width = 0.50,
					anchor = center,
					prompt_position = bottom,
					mirror = true,
				},
				file_ignore_patterns = { "node_modules/" },
				hidden = true,
				mappings = {
					i = {
						["<C-u>"] = false, -- To enable clear out input like in shell
					},
				},
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

    local tb = require('telescope.builtin')

    vim.keymap.set('n', 'f', function()
      tb.find_files({ find_command = { 'rg', '--files', '--hidden', '-g', '!.git' } })
    end)

    vim.keymap.set('n', 'g', tb.live_grep)
    vim.keymap.set('n', '<leader>fb', tb.buffers)
    vim.keymap.set('n', '<leader>f?', tb.git_commits)
    vim.keymap.set('n', '<leader>fs', tb.git_status)

    -- vim.keymap.set("n", "<leader>/", ":silent grep ", { desc = "Find todos" })
  end,
}
