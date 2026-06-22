local u = require("utils")

-- nvim 0.11 compatibility shim
-- if not vim.treesitter.ft_to_lang then
--   vim.treesitter.ft_to_lang = function(ft)
--     return vim.treesitter.language.get_lang(ft) or ft
--   end
-- end

return {
	"nvim-telescope/telescope.nvim",
	branch = "master",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local t = require("telescope")
		local tb = require("telescope.builtin")
		local ta = require("telescope.actions")

		-- keymappings ----------------------------

		u.keyset("n", "m", function()
			tb.find_files({ find_command = { "rg", "--files", "--hidden", "-g", "!.git" } })
		end)

		u.keyset("n", ".", tb.live_grep)

		u.keyset("n", "<leader>fb", tb.buffers)

		u.keyset("n", "<leader>fs", tb.git_commits)

		-- config --------------------------------

		t.setup({
			defaults = {
				layout_strategy = "horizontal",
				preview = {
					treesitter = false,
				},
				layout_config = {
					height = 0.95,
					width = 0.95,
					preview_width = 0.50,
					anchor = "center",
					prompt_position = "bottom",
					mirror = true,
				},
				file_ignore_patterns = { "node_modules/" },
				hidden = true,
				mappings = {},
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
	end,
}
