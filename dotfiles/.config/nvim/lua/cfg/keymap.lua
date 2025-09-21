-- global leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local function keymap(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

local default_opts =
	-- TODO: command for copying path to current buffer from root
	-- keymap('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
	-- TMUX
	keymap("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")

----- QoL ------
keymap("n", "<leader>h", "<CMD>nohlsearch<CR>") -- Nohl
keymap("n", "<leader>q", "<CMD>q!<CR>") -- Quit
-- Create shorctut for not saving, but default leader q should save
-- keymap("n", "<leader>q", "<CMD>q!<CR>") --
keymap("i", "jk", "<ESC>") -- Exit insert mode
keymap("n", "<leader>ww", "<CMD>write<CR>") -- Format and Save
keymap("n", "<leader>w", "<CMD>noautocmd write<CR>") -- Save with no formatting

-- -- Define a user command to remove trailing whitespace
-- vim.api.nvim_create_user_command('RemoveTrailingWhitespace', function()
--   local view = vim.fn.getcurpos()
--   vim.cmd.keepjumps([[
--     %s/\s\+$//e
--   ]])
--   vim.fn.setpos('.', view)
-- end, {})
--
-- -- Keymap to save without formatting and remove trailing whitespace
-- vim.keymap.set("n", "<leader>w", ":RemoveTrailingWhitespace | noautocmd write<CR>")

----- Windows ------
----- Window Creation
keymap("n", "<leader>v", "<CMD>vsplit<CR>")
-- keymap("n", "<leader>h", "<CMD>split<CR>")
----- Window Navigation
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-l>", "<C-w>l")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-j>", "<C-w>j")
----- Windows Resize
keymap("n", "<C-Left>", "<C-w><")
keymap("n", "<C-Right>", "<C-w>>")
keymap("n", "<C-Up>", "<C-w>+")
keymap("n", "<C-Down>", "<C-w>-")

----- Telescope ------
keymap("n", "<leader>f", "<cmd>Telescope find_filekcr>", { noremap = true, silent = true }) --  find files
keymap("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { noremap = true, silent = true }) -- live grep
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { noremap = true, silent = true }) -- find buffers
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { noremap = true, silent = true }) -- find help tags

----- Enhance defaults ------
-- keymapping <leader>fh to find help tags
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("x", "p", function()
	return 'pgv"' .. vim.v.register .. "y"
end, { remap = false, expr = true, silent = true })
