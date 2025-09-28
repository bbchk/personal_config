-- Global leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Helper function for key mappings
local function map(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

-----------------------------------
-- Quality of Life Keymaps
-----------------------------------

map("i", "jk", "<ESC>")

map("n", "<leader>h", "<CMD>nohlsearch<CR>")

map("n", "<leader>q", "<CMD>q!<CR>")

map("n", "<leader>ww", "<CMD>write<CR>")
map("n", "<leader>w", "<CMD>noautocmd write<CR>")

map("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")

-----------------------------------
-- Window Management
-----------------------------------

map("n", "<leader>v", "<CMD>vsplit<CR>")
map("n", "<leader>s", "<CMD>split<CR>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

map("n", "<C-Left>", "<C-w>>")
map("n", "<C-Right>", "<C-w><")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

map("n", "<leader>c", "<C-w>c", { desc = "Close window" })
map("n", "<leader>=", "<C-w>=", { desc = "Equalize windows" })

-- -- Buffer Management (using leader key)
-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
-- vim.keymap.set("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })
--
-- Tab Management (if you use tabs)
-- map("n", "<leader>tn", ":tabnext<CR>", { desc = "Next tab" })
-- map("n", "<leader>tp", ":tabprevious<CR>", { desc = "Previous tab" })
-- map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close tab" })

map("n", "<leader>b", ":tabnew<CR>", { desc = "New tab" })

for i = 1, 9 do
	map("n", tostring(i), i .. "gt", { desc = "Go to tab " .. i })
end

-----------------------------------
-- Ukrainian Keyboard Layout Mappings
-----------------------------------

-- Mappings for normal mode, based on the Ukrainian keyboard layout
-- Note: These keymaps might conflict with other plugins.
map("i", "ол", "jk")
map("n", "ф", "ggVG") -- Select all
map("n", "в", "d") -- Delete
map("n", "ц", "w") -- Forward word
map("n", "т", "e") -- End of word
map("n", "и", "b") -- Backward word
map("n", "н", "n") -- Next match
map("n", "щ", "o") -- New line below
map("n", "к", "r") -- Replace character
map("n", "д", "l") -- Move right
map("n", "л", "k") -- Move up
map("n", "ш", "i") -- Insert mode
map("n", "о", "j") -- Move down
map("n", "р", "h") -- Move left

-----------------------------------
-- Telescope Integration
-----------------------------------

-- # TODO: Should be in telescope file?
map("n", "<leader>f", "<cmd>Telescope find_files<cr>")
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-----------------------------------
-- Enhanced Default Mappings
-----------------------------------

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- Yank and paste without overwriting the register
map("x", "p", '"_dP')

-- TODO: command for copying path to current buffer from root
-- keymap('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
