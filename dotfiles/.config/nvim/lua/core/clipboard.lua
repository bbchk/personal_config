-- Clipboard: use native tools if a display is available, fall back to OSC52 in
-- containers (no X/Wayland) so yanks reach the host clipboard through the terminal.

-- Route y/d/p through the "+" register so they hit the clipboard provider below.
vim.opt.clipboard = "unnamedplus"

-- In a container the terminal is the reliable bridge to the host clipboard, so
-- prefer OSC52 even when DISPLAY is set: we now forward X11 for GUI apps like
-- turtlesim, and that DISPLAY would otherwise fool the check into using xclip
-- against the forwarded X server instead of reaching the real host clipboard.
local in_container = vim.fn.filereadable("/.dockerenv") == 1
	or vim.env.REMOTE_CONTAINERS ~= nil
	or vim.env.DEVCONTAINER ~= nil
	or vim.env.CODESPACES ~= nil

local has_display = not in_container
	and ((vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= "")
		or (vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= ""))

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
