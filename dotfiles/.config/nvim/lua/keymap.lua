local u = require("utils.index")

-- -- Helper function for key mappings
-- local function map(mode, lhs, rhs, opts)
-- 	opts = opts or {}
-- 	opts.silent = true
-- 	vim.keymap.set(mode, lhs, rhs, opts)
-- end

-----------------------------------
-- Global leader keys
-----------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------------
-- Quality of Life Keymaps
-----------------------------------

u.keyset("i", "jk", "<ESC>")

u.keyset("n", "<leader>h", "<CMD>nohlsearch<CR>")

u.keyset("n", "<leader>q", "<CMD>q!<CR>")

u.keyset("n", "<leader>ww", "<CMD>write<CR>")
u.keyset("n", "<leader>w", "<CMD>noautocmd write<CR>")

u.keyset("n", "<C-f>", ":silent !tmux neww tmux-sessionizer<CR>")

-- GIT
-----------------------------------

-- map("n", "", ":Gitsigns blame")
--


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

-- TODO: Buffer Management?
-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
-- vim.keymap.set("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })

-- Tab Management
u.keyset("n", "<S-l>", ":tabnext<CR>", { desc = "Next tab" })
u.keyset("n", "<S-h>", ":tabprevious<CR>", { desc = "Next tab" })

u.keyset("n", "<", ":-tabmove<CR>", { desc = "Move the tab to the left" })
u.keyset("n", ">", ":+tabmove<CR>", { desc = "Move the tab to the right" })

local function open_oil_in_new_tab()
    -- Get the name of the buffer where the command was executed (bufnr 0 is the current buffer)
    local current_file = vim.api.nvim_buf_get_name(0)
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    local path_to_open

    -- Determine the path to open in Oil
    if current_file ~= "" and buftype ~= 'terminal' and buftype ~= 'nofile' then
        -- If it's a file buffer, use the file's directory
        path_to_open = vim.fs.dirname(current_file)
    else
        -- If it's a terminal, a new scratch buffer, or an empty buffer, use the current working directory
        path_to_open = vim.loop.cwd()
    end

    -- Create a new tab page
    vim.cmd("tabnew")

    -- Check if the 'oil' plugin is available before calling it
    if pcall(require, "oil") then
        require("oil").open(path_to_open)
    else
        -- Display an error message if the plugin isn't found
        vim.cmd('echohl Error | echo "Error: Oil plugin not loaded. Please install oil.nvim." | echohl None')
    end
end

-- 2. Define the keymap (from your original request)
vim.keymap.set("n", "<leader>t", open_oil_in_new_tab, { noremap = true, desc = "New tab with Oil filesystem at current path" })

-- TODO: with telescope open as well
-- map("n", "<leader>t", ":tabnew | Oil<CR>", { noremap = true, desc = "New tab with Oil filesystem" })

-- map("n", "<leader>TODO", ":tabonly<CR>", { desc = "Tab only" })

-- TODO:
-- Map <M-1..9> to switch to tabs 1..9
-- for i = 1, 9 do
-- 	vim.keymap.set("n", "<M-t>" .. i, i .. "gt", { desc = "Go to tab " .. i })
-- end

-----------------------------------
-- Ukrainian Keyboard Layout Mappings
-----------------------------------

-- Mappings for normal mode, based on the Ukrainian keyboard layout
-- Note: These keymaps might conflict with other plugins.
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
-- Telescope Integration
-----------------------------------

-- # TODO: Should be in telescope file?
u.keyset("n", "<leader>f", "<cmd>Telescope find_files<cr>")
u.keyset("n", "<leader>fg", "<cmd>Telescope live_grep<cr>")
u.keyset("n", "<leader>fb", "<cmd>Telescope buffers<cr>")
u.keyset("n", "<leader>fh", "<cmd>Telescope help_tags<cr>")

-----------------------------------
-- Enhanced Default Mappings
-----------------------------------

u.keyset("n", "<C-d>", "<C-d>zz")
u.keyset("n", "<C-u>", "<C-u>zz")

u.keyset("n", "n", "nzzzv")
u.keyset("n", "N", "Nzzzv")

-- Yank and paste without overwriting the register
u.keyset("x", "p", '"_dP')

-- TODO: command for copying path to current buffer from root
-- keymap('n', '<leader>cp', ':let @+ = expand("%:p")<CR>', { noremap = true, silent = true })
