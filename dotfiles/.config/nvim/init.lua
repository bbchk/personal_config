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

require("keymap")
require("core.filetypes")
require("core.terminal")
require("core.tabs")

require("utils.sessionizer")

require("options")
require("plugin_manager")


if vim.env.SESSIONIZER_START == "true" then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()
      -- The key change is using "VimEnter" instead of "UIEnter".
      -- This event fires even when Neovim starts in the background.

      -- 1. Open a terminal in the first tab.
      vim.cmd("terminal")

      -- 2. Open a new tab (Neovim will focus it automatically).
      vim.cmd("tabnew")

      -- 3. Defer the interactive command to ensure the UI
      --    has had a chance to process the previous commands.
      vim.defer_fn(function()
        vim.cmd("Oil")
        vim.cmd("Telescope find_files")
      end, 50) -- 50ms delay is a safe bet
    end,
  })
end
