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

-- vim.lsp.enable({'clangd'})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
		vim.opt_local.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<space>t", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end)
