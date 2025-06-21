-- Define the mapping function
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

-- global leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- map('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
map('n', '<leader>cp', ':let @+ = expand("%:.")<CR>', { noremap = true, silent = true })

-- tmux
map("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")

-- Save
map("n", "<leader>ww", "<CMD>write<CR>")

-- Save with no formatting
map("n", "<leader>w", "<CMD>noautocmd write<CR>")

-- Nohl
map("n", "<leader>h", "<CMD>nohlsearch<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q!<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>r", "<CMD>Neotree focus<CR>")

-- New Windows
map("n", "<leader>v", "<CMD>vsplit<CR>")
-- map("n", "<leader>h", "<CMD>split<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- Mapping <leader>ff to find files
map("n", "<leader>f", "<cmd>Telescope find_files<cr>", opts)

-- Mapping <leader>fg to live grep
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", opts)

-- Mapping <leader>fb to find buffers
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts)

-- Mapping <leader>fh to find help tags
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts)

map("n", "<C-u>", "<C-u>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
