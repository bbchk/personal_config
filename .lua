-- We don't want any directory scanning anymore?
-- just open devcon inside a project that we open on host with sessionizer (we can revive old sessionizer implementation then, for every new devcon, we open sessinoizer that calls bash version of sessinizer.sh scritp)? 

local M = {}

local cached_dirs = nil
local cache_file = vim.fn.stdpath("cache") .. "/sessionizer_dir_cache.json"
local config = { search_dirs = {}, use_telescope = true }

-- VimEnter hooks
if vim.env.SESSIONIZER_START == "true" then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function() vim.defer_fn(M.sessionizer, 50) end,
  })
end

if vim.env.SESSIONIZER_SWITCH == "true" then
  vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
      vim.cmd("terminal\ntabnew")
      vim.defer_fn(function() vim.cmd("Oil\nTelescope find_files") end, 50)
    end,
  })
end

-- Cache
local function load_cache()
  local file = io.open(cache_file, "r")
  if not file then return nil end
  local content = file:read("*a")
  file:close()
  local ok, data = pcall(vim.fn.json_decode, content)
  return (ok and type(data) == "table") and data or nil
end

local function save_cache(dirs)
  local ok, encoded = pcall(vim.fn.json_encode, dirs)
  if not ok then return end
  local file = io.open(cache_file, "w")
  if not file then return end
  file:write(encoded)
  file:close()
end

-- Directory scanning
local function scan_dirs()
  local dirs = {}
  for _, search_dir in ipairs(config.search_dirs) do
    if vim.fn.isdirectory(search_dir) == 1 then
      local found = u.exec_cmd(string.format("find '%s' -mindepth 1 -maxdepth 1 -type d ! -name '.*'", search_dir))
      if found then
        for dir in found:gmatch("[^\r\n]+") do
          table.insert(dirs, dir)
        end
      end
    end
  end
  table.sort(dirs)
  return dirs
end

-- Tmux
local function handle_tmux_session(path)
  if not path or path == "" then return end
  local session_name = path:gsub("[./]", "_")

  vim.fn.system(string.format("tmux has-session -t '=%s' >/dev/null 2>&1", session_name))
  if vim.v.shell_error ~= 0 then
    u.exec_cmd(string.format("tmux new-session -s '%s' -c '%s' -d 'SESSIONIZER_SWITCH=true nvim'", session_name, path))
  end

  if not os.getenv("TMUX") then
    vim.fn.system(string.format("tmux attach-session -t '%s'", session_name))
    return
  end

  local current = (u.exec_cmd("tmux display-message -p '#S'") or ""):gsub("%s+$", "")
  if current ~= session_name then
    vim.fn.system(string.format("tmux switch-client -t '%s'", session_name))
  end
end

-- Picker (telescope with vim.ui.select fallback)
local function pick(dirs, callback)
  if config.use_telescope then
    local ok, pickers = pcall(require, "telescope.pickers")
    if ok then
      local finders = require("telescope.finders")
      local conf = require("telescope.config").values
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local home = vim.fn.expand("~")

      pickers.new({}, {
        prompt_title = "Select Workspace",
        finder = finders.new_table({
          results = dirs,
          entry_maker = function(entry)
            local display = entry:find(home, 1, true) == 1 and ("~" .. entry:sub(#home + 1)) or entry
            return { value = entry, display = display, ordinal = entry }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local sel = action_state.get_selected_entry()
            if sel then callback(sel.value) end
          end)
          return true
        end,
      }):find()
      return
    end
  end

  vim.ui.select(dirs, {
    prompt = "Select Workspace:",
    format_item = function(item)
      local parts = vim.split(item, "/")
      return #parts > 3 and (".../" .. table.concat(vim.list_slice(parts, #parts - 2), "/")) or item
    end,
  }, function(choice)
    if choice then callback(choice) end
  end)
end

-- Public API
function M.sessionizer()
  vim.fn.system("tmux start-server 2>/dev/null")
  cached_dirs = M.populate_cache({ quiet = true })
  if #cached_dirs == 0 then
    vim.notify("No directories found. Run :SessionizerRefreshCache", vim.log.levels.WARN)
    return
  end
  pick(cached_dirs, handle_tmux_session)
end

function M.populate_cache(opts)
  opts = opts or {}
  if opts.force then
    cached_dirs = nil
    pcall(vim.fn.delete, cache_file)
  end

  cached_dirs = cached_dirs or load_cache() or (function()
    local dirs = scan_dirs()
    save_cache(dirs)
    return dirs
  end)()

  if not opts.quiet then
    vim.notify("Sessionizer cache: " .. #cached_dirs .. " directories.", vim.log.levels.INFO)
  end
  return cached_dirs
end

function M.refresh_cache()
  cached_dirs = nil
  pcall(vim.fn.delete, cache_file)
  vim.notify("Sessionizer cache cleared.", vim.log.levels.INFO)
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  if opts.keybind then
    vim.keymap.set("n", opts.keybind, M.sessionizer, { desc = opts.desc or "Open Sessionizer" })
  end

  vim.api.nvim_create_user_command("SessionizerRefreshCache", M.refresh_cache, { desc = "Clear sessionizer cache" })
  vim.api.nvim_create_user_command("SessionizerPopulateCache", function(cmd_opts)
    M.populate_cache({ force = cmd_opts.bang })
  end, { desc = "Populate sessionizer cache", bang = true })
end

M.setup({
  search_dirs = {
    vim.fn.expand("~"),
    vim.fn.expand("~/dev/my"),
    vim.fn.expand("~/dev/ib"),
    vim.fn.expand("~/dev/lw"),
    vim.fn.expand("~/dev"),
    vim.fn.expand("~/pers/xdg"),
    vim.fn.expand("~/exercism/cpp"),
  },
  use_telescope = true,
  keybind = "<C-f>",
  desc = "Open Sessionizer",
})

return M
