local U = {}

-- Define a sub-table for filesystem related utilities
U.fs = {}

--[[
A helper function to create keymaps with silent = true by default.
--]]
function U.keyset(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = true
	vim.keymap.set(mode, lhs, rhs, opts)
end

--[[
Opens a new tab and runs the oil file explorer in the directory of the
current file, or the current working directory if it's not a file buffer.
--]]
function U.fs.open_new_tab_at_same_path()
    -- Get the name of the buffer where the command was executed (bufnr 0 is the current buffer)
    local current_file = vim.api.nvim_buf_get_name(0)
    local buftype = vim.api.nvim_buf_get_option(0, 'buftype')
    local path_to_open

    -- Determine the path to open in Oil
    if current_file ~= "" and buftype ~= 'terminal' and buftype ~= 'nofile' then
        -- If it's a file buffer, use the file's directory
        path_to_open = vim.fs.dirname(current_file)
    else
        -- If it's a terminal, a new scratch buffer, or an empty buffer, use the current working directory
        path_to_open = vim.uv.cwd()
    end

    -- Create a new tab page
    vim.cmd("tabnew")

    -- Check if the 'oil' plugin is available before calling it
    if pcall(require, "oil") then
        require("oil").open(path_to_open)
    else
        -- Display an error message if the plugin isn't found
        vim.cmd('echohl Error | echo "Error: Oil plugin not loaded. Please install oil.nvim." | echohl None')
    end
end

function U.exec_cmd(cmd)
  local handle = io.popen(cmd)

  if not handle then
    return nil
  end

  local result = handle:read("*a")

  handle:close()

  return result and result:gsub("\n$", "") or nil
end

local function U.log(msg)
	local log_file = vim.fn.stdpath("cache") .. "/sessionizer.log"
	local timestamp = os.date("%Y-%m-%d %H:%M:%S")
	local formatted_msg = string.format("[%s] %s\n", timestamp, msg)

	local file = io.open(log_file, "a")
	if file then
		file:write(formatted_msg)
		file:close()
	end
end

return U

