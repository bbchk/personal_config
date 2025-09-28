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

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("keymap")
require("options")
require("plugin_manager")

vim.filetype.add({
	extension = {
		conf = "conf",
		env = "dotenv",
		tiltfile = "tiltfile",
		Tiltfile = "tiltfile",
		slim = "slim",
	},
	filename = {
		[".env"] = "dotenv",
		["tsconfig.json"] = "jsonc",
		[".yamlfmt"] = "yaml",
	},
	pattern = {
		["%.env%.[%w_.-]+"] = "dotenv",
		["Dockerfile.*"] = "dockerfile",
	},
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.scrolloff = 0

		vim.bo.filetype = "terminal"
	end,
})

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>k", function()
	vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 12)
	vim.wo.winfixheight = true
	vim.cmd.term()
end)

-- Set a custom tabline
vim.o.tabline = "%!v:lua.Tabline()"

-- Function to generate tab names based on buffer type / filename
function _G.Tabline()
  local s = ""
  for i = 1, vim.fn.tabpagenr("$") do
    local buflist = vim.fn.tabpagebuflist(i)
    local winnr = vim.fn.tabpagewinnr(i)
    local buf = buflist[winnr]
    local filetype = vim.bo[buf].filetype
    local name

    if filetype == "oil" then
      local dirname = vim.fn.expand("#" .. buf .. ":h:t")
      if dirname ~= "" then
        name = "D " .. dirname
      else
        name = "dir-view"
      end
    else
      local filename = vim.fn.expand("#" .. buf .. ":t")
      if filename ~= "" then
        name = "F " .. filename
      else
        name = "[No Name]"
      end
    end

    -- Highlight selected tab
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- Clickable tab
    s = s .. "%" .. i .. "T " .. name .. " "
  end

  s = s .. "%#TabLineFill#"
  return s
end

-- Optional: refresh tabline when switching buffers/windows
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
  callback = function()
    vim.cmd("redrawtabline")
  end,
})

