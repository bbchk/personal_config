
-- I want to have shortcut for opening `vim .`, as i do it too often
-- I want to have panes named after filename it has open in tmux

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
