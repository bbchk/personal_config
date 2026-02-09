vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc>", "<c-\\><c-n>")

-- -- Open a terminal in current buffer
-- vim.keymap.set("n", "<leader>k", function()
-- 	vim.cmd.new()
-- 	vim.cmd.wincmd("J")
-- 	vim.api.nvim_win_set_height(0, 12)
-- 	vim.wo.winfixheight = true
-- 	vim.cmd.term()
-- end)

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>k", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 20)
	vim.wo.winfixheight = true
	vim.cmd.term()
end)

vim.env.PATH = vim.env.PATH .. ":/usr/local/go/bin:" .. vim.fn.expand("$HOME") .. "/go/bin"
