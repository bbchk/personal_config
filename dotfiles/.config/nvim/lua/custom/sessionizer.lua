local u = require("utils.index")

local M = {}

local cached_dirs = nil
local cache_file = vim.fn.stdpath("cache") .. "/sessionizer_dir_cache.json"

if vim.env.SESSIONIZER_START == "true" then
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		once = true,
		callback = function()
			vim.defer_fn(function()
				M.sessionizer()
			end, 50)
		end,
	})
end

if vim.env.SESSIONIZER_SWITCH == "true" then
	vim.api.nvim_create_autocmd("VimEnter", {
		pattern = "*",
		once = true,
		callback = function()
			vim.cmd([[
        terminal
        tabnew
      ]])
			vim.defer_fn(function()
				vim.cmd([[
          Oil
          Telescope find_files
        ]])
			end, 50)
		end,
	})
end

-- Configuration
local config = {
	search_dirs = {
		vim.fn.expand("~"),
		vim.fn.expand("~/dev/my"),
		vim.fn.expand("~/dev/ib"),
	},
	use_telescope = true,
}

local function get_bare_repo_session_name(dir)
	local is_git_repo = u.exec_cmd(string.format("git -C '%s' rev-parse --git-dir 2>/dev/null", dir))
	local is_bare_repo = u.exec_cmd(string.format("git -C '%s' rev-parse --is-bare-repository 2>/dev/null", dir))
	if not is_git_repo or is_bare_repo ~= "true" then
		return nil
	end
	local worktree_list = u.exec_cmd(string.format("git -C '%s' worktree list --porcelain 2>/dev/null", dir))
	if not worktree_list then
		return nil
	end
	local worktree_paths = {}
	for line in worktree_list:gmatch("[^\r\n]+") do
		if line:match("^worktree ") then
			local path = line:match("^worktree (.+)")
			if path and not path:match("%.bare$") then
				table.insert(worktree_paths, path)
			end
		end
	end
	return #worktree_paths > 0 and worktree_paths or nil
end

local function get_directories()
	u.log("Performing slow directory scan...")
	local dirs = {}
	for _, search_dir in ipairs(config.search_dirs) do
		if vim.fn.isdirectory(search_dir) == 1 then
			local found_dirs =
				u.exec_cmd(string.format("find '%s' -mindepth 1 -maxdepth 1 -type d ! -name '.*'", search_dir))
			if found_dirs then
				for dir in found_dirs:gmatch("[^\r\n]+") do
					local bare_names = get_bare_repo_session_name(dir)
					if bare_names then
						for _, name in ipairs(bare_names) do
							table.insert(dirs, name)
						end
					else
						table.insert(dirs, dir)
					end
				end
			end
		end
	end
	table.sort(dirs)
	u.log("Scan finished. Found " .. #dirs .. " directories.")
	return dirs
end

local function ensure_tmux_server()
	local result = u.exec_cmd("tmux ls 2>/dev/null")
	if not result then
		u.exec_cmd("tmux start-server 2>/dev/null")
	end
	return true
end

local function handle_tmux_session(session_path)
	u.log("handle_tmux_session called with path: " .. tostring(session_path))
	if not session_path or session_path == "" then
		u.log("Path is nil or empty. Aborting.")
		return
	end
	local session_name = (session_path:gsub("[./]", "_"))
	u.log("Generated session_name: " .. session_name)

	local check_cmd = string.format("tmux has-session -t '=%s'", session_name)
	vim.fn.system(check_cmd .. " >/dev/null 2>&1")
	local session_exists = (vim.v.shell_error == 0)

	u.log("Session '" .. session_name .. "' exists (exact match): " .. tostring(session_exists))

	if not session_exists then
		local create_cmd = string.format(
			"tmux new-session -s '%s' -c '%s' -d 'SESSIONIZER_SWITCH=true nvim'",
			session_name,
			session_path
		)
		u.log("Creating new session with command: " .. create_cmd)
		u.exec_cmd(create_cmd)
	end

	local tmux_env = os.getenv("TMUX")
	if not tmux_env then
		u.log("Not in tmux. Attaching to session.")
		local attach_cmd = string.format("tmux attach-session -t '%s'", session_name)
		vim.fn.system(attach_cmd)
	else
		local current_session = u.exec_cmd("tmux display-message -p '#S'")
		if current_session then
			current_session = current_session:gsub("%s+$", "")
		end
		u.log("Current tmux session: '" .. tostring(current_session) .. "'")
		u.log("Target tmux session: '" .. tostring(session_name) .. "'")

		if current_session ~= session_name then
			u.log("Switching client...")
			local command = string.format("tmux switch-client -t '%s'", session_name)
			vim.fn.system(command)
		else
			u.log("Already in target session. Not switching.")
		end
	end
end

local function telescope_picker(dirs, callback)
	u.log("Opening Telescope picker.")
	local telescope_ok, _ = pcall(require, "telescope")
	if not telescope_ok then
		u.log("Telescope not found.", "ERROR")
		return false
	end
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	pickers
		.new({}, {
			prompt_title = "Select Workspace",
			finder = finders.new_table({
				results = dirs,
				-- THIS IS THE CHANGED PART --
				entry_maker = function(entry)
					local display = entry
					local home = vim.fn.expand("~")
					-- Replace the user's home directory with '~' for a cleaner look
					if display:find(home, 1, true) == 1 then
						display = "~" .. display:sub(#home + 1)
					end
					return { value = entry, display = display, ordinal = entry }
				end,
			}),
			sorter = conf.generic_sorter({}),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					u.log("Telescope selection action triggered.")
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					if selection and selection.value then
						u.log("Selection successful. Value: " .. selection.value)
						callback(selection.value)
					else
						u.log("Selection FAILED. get_selected_entry() returned nil or no value.", "ERROR")
					end
				end)
				return true
			end,
		})
		:find()
	return true
end

local function select_picker(dirs, callback)
	vim.ui.select(dirs, {
		prompt = "Select Workspace:",
		format_item = function(item)
			local parts = vim.split(item, "/")
			if #parts > 3 then
				return ".../" .. table.concat(vim.list_slice(parts, #parts - 2), "/")
			end
			return item
		end,
	}, function(choice)
		if choice then
			callback(choice)
		end
	end)
end

function M.sessionizer()
	u.log("--- Sessionizer Run Started ---")
	ensure_tmux_server()

	if not cached_dirs then
		u.log("In-memory cache is empty. Checking file cache.")
		local file = io.open(cache_file, "r")
		if file then
			local content = file:read("*a")
			file:close()
			local ok, decoded = pcall(vim.fn.json_decode, content)
			if ok and type(decoded) == "table" then
				u.log("Successfully loaded " .. #decoded .. " dirs from file cache.")
				cached_dirs = decoded
			else
				u.log("Cache file is invalid.")
			end
		end
	else
		u.log("Using in-memory cache.")
	end

	if not cached_dirs then
		cached_dirs = get_directories() -- Run the slow function
		local ok, encoded = pcall(vim.fn.json_encode, cached_dirs)
		if ok then
			local file = io.open(cache_file, "w")
			if file then
				file:write(encoded)
				file:close()
				u.log("Saved new cache to file.")
			end
		end
	end

	if #cached_dirs == 0 then
		vim.notify("No directories found. Run :SessionizerRefreshCache", vim.log.levels.WARN)
		return
	end

	local callback = function(selected_dir)
		u.log("Main callback was called with: " .. selected_dir)
		handle_tmux_session(selected_dir)
	end
	if config.use_telescope then
		if not telescope_picker(cached_dirs, callback) then
			select_picker(cached_dirs, callback)
		end
	else
		select_picker(cached_dirs, callback)
	end
end

function M.add_worktree()
	-- 1. Get the root of the repository (where the .bare dir and .git file are)
	local repo_root_list = vim.fn.systemlist("git rev-parse --show-toplevel")
	if vim.v.shell_error ~= 0 or not repo_root_list[1] then
		vim.notify("Not a git repository.", vim.log.levels.ERROR)
		return
	end
	local repo_root = repo_root_list[1]

	-- 2. Verify this is our special bare repo setup by checking if '.git' is a file, not a directory
	if vim.fn.isdirectory(repo_root .. "/.git") == 1 then
		vim.notify("This command is only for bare repositories with worktrees.", vim.log.levels.WARN)
		return
	end

	-- 3. Prompt user for the branch name
	vim.ui.input({ prompt = "Enter new branch/worktree name: " }, function(branch_name)
		if not branch_name or branch_name == "" then
			vim.notify("Worktree creation cancelled.", vim.log.levels.INFO)
			return
		end

		-- 4. Sanitize the branch name for use as a directory name, same as your script
		local dir_name = branch_name:gsub("/", "_")

		-- 5. Check if the branch exists on the remote 'origin'
		local check_branch_cmd = string.format("git -C '%s' branch -r | grep -q 'origin/%s$'", repo_root, branch_name)
		vim.fn.system(check_branch_cmd)
		local branch_exists_on_remote = (vim.v.shell_error == 0)

		local worktree_cmd

		if branch_exists_on_remote then
			-- Branch exists, just create a worktree from it
			vim.notify(string.format("Branch '%s' found on remote. Creating worktree...", branch_name))
			worktree_cmd = string.format("git -C '%s' worktree add '%s' '%s'", repo_root, dir_name, branch_name)
		else
			-- Branch does not exist, so we create a new local branch first
			vim.notify(string.format("Branch '%s' not found. Creating new local branch and worktree...", branch_name))
			worktree_cmd = string.format("git -C '%s' worktree add -b '%s' '%s'", repo_root, branch_name, dir_name)
		end

		-- 6. Execute the final command and give feedback
		local output = vim.fn.system(worktree_cmd)
		if vim.v.shell_error == 0 then
			vim.notify(
				string.format("Successfully created worktree '%s' for branch '%s'.", dir_name, branch_name),
				vim.log.levels.INFO
			)
			-- As a bonus, clear the cache so the new directory appears next time
			M.refresh_cache()
		else
			vim.notify(string.format("Failed to create worktree. Error:\n%s", output), vim.log.levels.ERROR)
		end
	end)
end

function M.refresh_cache()
	u.log("Cache cleared by user.")
	cached_dirs = nil
	pcall(vim.fn.delete, cache_file)
	vim.notify("Sessionizer cache cleared. The next run will perform a full scan.", vim.log.levels.INFO)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})
	if opts and opts.keybind then
		vim.keymap.set("n", opts.keybind, M.sessionizer, { desc = opts.desc or "Open Sessionizer" })
	end

	if opts and opts.worktree_keybind then
		vim.keymap.set(
			"n",
			opts.worktree_keybind.key,
			M.add_worktree,
			{ desc = opts.worktree_keybind.desc or "Add Git Worktree" }
		)
	end

	vim.api.nvim_create_user_command(
		"SessionizerRefreshCache",
		M.refresh_cache,
		{ desc = "Clears the sessionizer directory cache" }
	)
end

M.setup({
	search_dirs = { vim.fn.expand("~"), vim.fn.expand("~/dev/my"), vim.fn.expand("~/dev/ib"), vim.fn.expand("~/dev"), vim.fn.expand("~/pers/xdg") },
	use_telescope = true,
	keybind = "f",
	desc = "Open Sessionizer",
})

return M
