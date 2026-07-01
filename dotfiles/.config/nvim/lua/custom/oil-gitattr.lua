-- Highlight files in Oil that have git attributes (e.g. filter=gpg)

local M = {}

vim.api.nvim_set_hl(0, "OilGpgFilter", { fg = "#e5c07b", italic = true })

local ns = vim.api.nvim_create_namespace("oil_gitattr")

local function get_gpg_entries(dir)
  -- Get git repo root
  local root = vim.fn.system("git -C " .. vim.fn.shellescape(dir) .. " rev-parse --show-toplevel 2>/dev/null"):gsub("\n", "")
  if vim.v.shell_error ~= 0 or root == "" then return {} end

  -- Get relative path from repo root to this dir
  local rel = dir:gsub("^" .. vim.pesc(root) .. "/?", "")

  -- List entries in this directory
  local entries = vim.fn.globpath(dir, "*", false, true)
  if #entries == 0 then return {} end

  -- Build list of relative paths for git check-attr
  local rel_paths = {}
  for _, entry in ipairs(entries) do
    local name = vim.fn.fnamemodify(entry, ":t")
    if rel ~= "" then
      table.insert(rel_paths, rel .. "/" .. name)
    else
      table.insert(rel_paths, name)
    end
  end

  -- Run git check-attr on all entries at once
  local cmd = "git -C " .. vim.fn.shellescape(root) .. " check-attr filter -- " .. table.concat(vim.tbl_map(vim.fn.shellescape, rel_paths), " ") .. " 2>/dev/null"
  local output = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then return {} end

  local gpg_names = {}
  for line in output:gmatch("[^\n]+") do
    local path, value = line:match("^(.+): filter: (.+)$")
    if path and value == "gpg" then
      local name = vim.fn.fnamemodify(path, ":t")
      gpg_names[name] = true
    end
  end
  return gpg_names
end

function M.highlight_buffer(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local ok, oil = pcall(require, "oil")
  if not ok then return end

  local dir = oil.get_current_dir(bufnr)
  if not dir then return end

  local gpg_names = get_gpg_entries(dir)
  if vim.tbl_isempty(gpg_names) then
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
    return
  end

  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  -- Parse Oil buffer lines to extract entry names
  -- Oil lines have concealed ID prefixes like "/014 ib/" — strip everything up to the last space before the name
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    -- Strip all non-printable chars and Oil's internal ID prefix, then trim
    local cleaned = line:gsub("[^%g%s]", ""):gsub("^/%d+%s+", ""):gsub("^%s+", ""):gsub("/$", "")
    if cleaned ~= "" and gpg_names[cleaned] then
        vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, 0, {
          virt_text = { { "🗝", "OilGpgFilter" } },
          virt_text_pos = "eol",
          line_hl_group = "OilGpgFilter",
          priority = 100,
        })
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("OilGitAttr", { clear = true })

  vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged" }, {
    group = group,
    callback = function(args)
      if vim.bo[args.buf].filetype == "oil" then
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(args.buf) then
            M.highlight_buffer(args.buf)
          end
        end, 150)
      end
    end,
  })
end

return M
