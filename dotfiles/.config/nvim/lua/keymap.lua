local u = require("utils")

-----------------------------------
-- Global leader keys
-----------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- TODO:
-- nnoremap <silent><esc><esc> :nohlsearch<CR>

-----------------------------------
-- Quality of Life Keymaps
-----------------------------------

u.keyset("i", "jk", "<ESC>")

u.keyset("n", "<leader>h", "<CMD>nohlsearch<CR>")

u.keyset("n", "<leader>q", "<CMD>q!<CR>")

u.keyset("n", "<leader>ww", "<CMD>write<CR>")
u.keyset("n", "<leader>w", "<CMD>noautocmd write<CR>")

u.keyset(
	"n",
	"<leader>r",
	"<Cmd>lua require('custom.sessionizer').refresh_cache()<CR>",
	{ silent = true, desc = "Sessionizer: Refresh cache" }
)

-----------------------------------
-- Window Management
-----------------------------------

u.keyset("n", "<leader>v", "<CMD>vsplit<CR>")
u.keyset("n", "<leader>s", "<CMD>split<CR>")

u.keyset("n", "<C-h>", "<C-w>h")
u.keyset("n", "<C-l>", "<C-w>l")
u.keyset("n", "<C-k>", "<C-w>k")
u.keyset("n", "<C-j>", "<C-w>j")

u.keyset("n", "<C-Left>", "<C-w>>")
u.keyset("n", "<C-Right>", "<C-w><")
u.keyset("n", "<C-Up>", "<C-w>+")
u.keyset("n", "<C-Down>", "<C-w>-")

u.keyset("n", "<leader>c", "<C-w>c", { desc = "Close window" })
u.keyset("n", "<leader>=", "<C-w>=", { desc = "Equalize windows" })

-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
-- vim.keymap.set("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })

-- Tab Management
u.keyset("n", "<S-l>", ":tabnext<CR>", { desc = "Next tab" })
u.keyset("n", "<S-h>", ":tabprevious<CR>", { desc = "Next tab" })

u.keyset("n", "<", ":-tabmove<CR>", { desc = "Move the tab to the left" })
u.keyset("n", ">", ":+tabmove<CR>", { desc = "Move the tab to the right" })

u.keyset(
	"n",
	"<leader>t",
	u.fs.open_new_tab_at_same_path,
	{ remap = false, desc = "Open new tab with at current path" }
)

for i = 1, 9 do
	u.keyset("n", "<M-" .. i .. ">", i .. "gt", { desc = "Go to tab " .. i })
end

for i = 1, 9 do
	u.keyset("n", "<C-" .. i .. ">", i .. "gt", { desc = "Go to tab " .. i })
end

-----------------------------------
-- Ukrainian Keyboard Layout Mappings
-----------------------------------

u.keyset("i", "ол", "jk")
u.keyset("n", "ф", "ggVG") -- Select all
u.keyset("n", "в", "d") -- Delete
u.keyset("n", "ц", "w") -- Forward word
u.keyset("n", "т", "e") -- End of word
u.keyset("n", "и", "b") -- Backward word
u.keyset("n", "н", "n") -- Next match
u.keyset("n", "щ", "o") -- New line below
u.keyset("n", "к", "r") -- Replace character
u.keyset("n", "д", "l") -- Move right
u.keyset("n", "л", "k") -- Move up
u.keyset("n", "ш", "i") -- Insert mode
u.keyset("n", "о", "j") -- Move down
u.keyset("n", "р", "h") -- Move left

-----------------------------------
-- Enhanced Default Mappings
-----------------------------------

u.keyset("n", "<C-d>", "<C-d>zz")
u.keyset("n", "<C-u>", "<C-u>zz")

u.keyset("n", "n", "nzzzv")
u.keyset("n", "N", "Nzzzv")

u.keyset("x", "p", '"_dP') -- Yank and paste without overwriting the register

-- command for copying path to current buffer from root
-- keymap('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
