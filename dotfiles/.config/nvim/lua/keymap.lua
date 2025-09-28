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

-- TODO: Buffer Management?
-- vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
-- vim.keymap.set("n", "<leader>bd", ":bd<CR>", { desc = "Delete buffer" })
-- vim.keymap.set("n", "<leader>bl", ":ls<CR>", { desc = "List buffers" })

-- Tab Management
map("n", "<S-l>", ":tabnext<CR>", { desc = "Next tab" })
map("n", "<S-h>", ":tabprevious<CR>", { desc = "Next tab" })

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
