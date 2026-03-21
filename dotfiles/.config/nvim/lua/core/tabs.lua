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
        name = "🖿" .. dirname
      else
        name = "[DIR]"
      end
    else
      local filename = vim.fn.expand("#" .. buf .. ":t")
      if filename ~= "" then
        name = "🗎" .. filename
      else
        name = "[FILE]"
      end
    end

    -- Highlight selected tab
    if i == vim.fn.tabpagenr() then
      s = s .. "%#TabLineSel#"
    else
      s = s .. "%#TabLine#"
    end

    -- Clickable tab (number prefix + name)
    s = s .. "%" .. i .. "T " .. i .. ":" .. name .. " "
  end

  s = s .. "%#TabLineFill#"
  return s
end

-- Refresh tabline when switching buffers/windows
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
  callback = function()
    vim.cmd("redrawtabline")
  end,
})
