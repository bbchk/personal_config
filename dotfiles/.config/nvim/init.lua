--
--
--    The dino is friendly!
--    It could bite just to get know ya.
--
--                __
--               / _)
--      _.----._/ /
--     /         /
--  __/ (  | (  |
-- /__.-'|_|--|_|
--
--
--

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("cfg")
require("cfg.lazy")

vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		tiltfile = "tiltfile",
		Tiltfile = "tiltfile",
		slim = "slim",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
		["Dockerfile.*"] = "dockerfile",
	},
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		local filename = vim.fn.expand("%:t")

		if filetype == "oil" then
			local dirname = vim.fn.expand("%:h:t")
			if dirname ~= "" then
				vim.fn.system(string.format("tmux rename-window 'D %s'", dirname))
			else
				vim.fn.system("tmux rename-window dir-view")
			end
		elseif filename ~= "" then
			vim.fn.system(string.format("tmux rename-window 'F %s'", filename))
		end
	end,
})

-- Reset when leaving Neovim
vim.api.nvim_create_autocmd("VimLeave", {
	pattern = "*",
	callback = function()
		vim.fn.system("tmux rename-window 'nvim'")
	end,
})
