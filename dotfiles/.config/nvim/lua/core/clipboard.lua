-- Clipboard: use native tools if a display is available, fall back to OSC52 in
-- containers (no X/Wayland) so yanks reach the host clipboard through the terminal.

-- Route y/d/p through the "+" register so they hit the clipboard provider below.
vim.opt.clipboard = "unnamedplus"

local has_display = (vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= "")
	or (vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= "")

if not has_display then
	local osc52 = require("vim.ui.clipboard.osc52")
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = osc52.copy("+"),
			["*"] = osc52.copy("*"),
		},
		paste = {
			["+"] = osc52.paste("+"),
			["*"] = osc52.paste("*"),
		},
	}
end
