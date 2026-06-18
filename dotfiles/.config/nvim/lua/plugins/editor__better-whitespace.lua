return {
	"ntpeters/vim-better-whitespace",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- Custom highlight colors
		vim.api.nvim_set_hl(0, "ExtraWhitespace", {
			bg = "#485a73", -- Bright red background
			fg = "#ffffff", -- White foreground
			-- Alternative color options:
			-- bg = "#e06c75",  -- Softer red
			-- bg = "#f1fa8c",  -- Yellow
			-- bg = "",  -- Purple
			-- bg = "#ff79c6",  -- Pink
		})

		vim.g.better_whitespace_enabled = 1

		-- Enable highlighting in specific filetypes (empty = all files)
		vim.g.better_whitespace_filetypes_blacklist = {
			"diff",
			"git",
			"gitcommit",
			"unite",
			"qf",
			"help",
			"markdown",
			"fugitive",
		}

		-- Show whitespace in insert mode (can be distracting, set to 0 to disable)
		vim.g.show_spaces_that_precede_tabs = 0

		-- Strip whitespace on save for specific filetypes
		vim.g.strip_whitespace_on_save = 1
		vim.g.strip_whitelines_at_eof = 1
		vim.g.strip_whitespace_confirm = 0 -- Don't ask for confirmation

		-- Only strip whitespace for these filetypes (empty = all files)
		vim.g.better_whitespace_filetypes_blacklist = {
			"diff",
			"git",
			"gitcommit",
			"unite",
			"qf",
			"help",
			"markdown",
		}

    -- TODO: move
		-- Keymaps for manual whitespace management
		-- vim.keymap.set('n', '<leader>ws', ':StripWhitespace<CR>',
		--   { desc = 'Strip trailing whitespace', silent = true })
		--
		-- vim.keymap.set('n', '<leader>wt', ':ToggleWhitespace<CR>',
		--   { desc = 'Toggle whitespace highlighting', silent = true })

		-- Advanced: Custom function to strip whitespace only in modified lines
		-- local function strip_whitespace_on_changed_lines()
		--   local view = vim.fn.winsaveview()
		--   -- Only strip whitespace on lines that have been modified
		--   vim.cmd([[%s/\(\%#\@!\s\)\+$//e]])
		--   vim.fn.winrestview(view)
		-- end

		-- vim.keymap.set('n', '<leader>wc', strip_whitespace_on_changed_lines,
		--   { desc = 'Strip whitespace on changed lines', silent = true })

		-- Auto-command to disable in certain contexts
		-- vim.api.nvim_create_autocmd("FileType", {
		--   pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
		--   callback = function()
		--     vim.b.better_whitespace_enabled = 0
		--   end,
		-- })

		-- Optional: Show current whitespace status in statusline
		-- Add this to your statusline: %{get(b:, 'better_whitespace_enabled', g:better_whitespace_enabled) ? '[WS]' : ''}
	end,
}
