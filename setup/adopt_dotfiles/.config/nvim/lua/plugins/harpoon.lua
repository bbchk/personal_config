return {
	"theprimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("harpoon"):setup()
	end,
	keys = {
		{
			"<leader>p",
			function()
				require("harpoon"):list():append()
			end,
			desc = "harpoon file",
		},
		{
			"<leader>a",
			function()
				local harpoon = require("harpoon")
				harpoon.ui:toggle_quick_menu(harpoon:list())

				-- Add mapping to close the quick menu with Ctrl + c
				vim.api.nvim_buf_set_keymap(
					0, -- Current buffer
					"n", -- Normal mode
					"<C-c>", -- Ctrl + c
					":q<CR>", -- Command to close the window
					{ noremap = true, silent = true, desc = "Close Harpoon menu with Ctrl + c" }
				)
			end,
			desc = "harpoon quick menu",
		},
		{
			"<leader>1",
			function()
				require("harpoon"):list():select(1)
			end,
			desc = "harpoon to file 1",
		},
		{
			"<leader>2",
			function()
				require("harpoon"):list():select(2)
			end,
			desc = "harpoon to file 2",
		},
		{
			"<leader>3",
			function()
				require("harpoon"):list():select(3)
			end,
			desc = "harpoon to file 3",
		},
		{
			"<leader>4",
			function()
				require("harpoon"):list():select(4)
			end,
			desc = "harpoon to file 4",
		},
		{
			"<leader>5",
			function()
				require("harpoon"):list():select(5)
			end,
			desc = "harpoon to file 5",
		},
	},
}
