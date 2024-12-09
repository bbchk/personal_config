return {
	--	"christianchiarulli/nvcode-color-schemes.vim",
	"folke/tokyonight.nvim",
	--	"EdenEast/nightfox.nvim",
	---	"catppuccin/nvim",
	--	name = "catppuccin",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme tokyonight")
		-- vim.cmd("colorscheme nightfox")
		--		vim.cmd("colorscheme catppuccin")
		--		vim.cmd("colorscheme nvcode")
	end,
}
