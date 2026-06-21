-- Clipboard: use native tools on host, fall back to OSC52 in containers

local function has_native_clipboard()
  return vim.fn.executable("pbcopy") == 1   -- macOS
    or vim.fn.executable("xclip") == 1      -- Linux X11
    or vim.fn.executable("xsel") == 1       -- Linux X11
    or vim.fn.executable("wl-copy") == 1    -- Linux Wayland
end

if has_native_clipboard() then
  vim.opt.clipboard = "unnamedplus"
else
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end

