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
    slim = "slim"
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

-- Automatically set tmux pane title when opening files in Neovim
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
  pattern = "*",
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename ~= "" then
      vim.fn.system("tmux rename-window " .. filename .. "")
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
