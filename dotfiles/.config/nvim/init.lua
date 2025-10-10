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

require("options")
require("plugin_manager")




if vim.env.SESSIONIZER_START == "true" then
  -- Create an autocommand that runs only once when the UI is stable
  vim.api.nvim_create_autocmd("UIEnter", {
    pattern = "*",
    once = true,
    callback = function()
      vim.cmd("terminal")

      vim.cmd("tabnew")

      vim.cmd("Oil")

      -- 4. CRITICAL: Defer the interactive command (Telescope)
      --    to give the UI time to draw the Oil buffer first.
      vim.defer_fn(function()
        vim.cmd("Telescope find_files")
      end, 50) -- 50ms is usually a safe delay
    end,
  })
end
