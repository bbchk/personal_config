-- Clipboard: use native tools if display is available, fall back to OSC52 in containers

local has_display = (vim.env.DISPLAY ~= nil and vim.env.DISPLAY ~= "")
	or (vim.env.WAYLAND_DISPLAY ~= nil and vim.env.WAYLAND_DISPLAY ~= "")

if has_display then
	vim.opt.clipboard = "unnamedplus"
else
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			[""] = require("vim.ui.clipboard.osc52").copy(""),
		},
		paste = {
			["+"] = require("vim.ui.clipboard.osc52").paste("+"),
			[""] = require("vim.ui.clipboard.osc52").paste(""),
		},
	}
end
