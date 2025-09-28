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

require("cfg")
require("cfg.lazy")

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

-- vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
-- 	pattern = "*",
-- 	callback = function()
-- 		local filetype = vim.bo.filetype
-- 		local filename = vim.fn.expand("%:t")
--
-- 		if filetype == "oil" then
-- 			local dirname = vim.fn.expand("%:h:t")
-- 			if dirname ~= "" then
-- 				vim.fn.system(string.format("tmux rename-window 'D %s'", dirname))
-- 			else
-- 				vim.fn.system("tmux rename-window dir-view")
-- 			end
-- 		elseif filename ~= "" then
-- 			vim.fn.system(string.format("tmux rename-window 'F %s'", filename))
-- 		end
-- 	end,
-- })
--
-- -- Reset when leaving Neovim
-- vim.api.nvim_create_autocmd("VimLeave", {
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.fn.system("tmux rename-window 'nvim'")
-- 	end,
-- })

-- vim.lsp.enable({'clangd'})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

vim.api.nvim_create_autocmd("TermOpen", {
	group = vim.api.nvim_create_augroup("custom-term-open", {}),
	callback = function()
		vim.opt_local.number = true
		vim.opt_local.relativenumber = true
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

