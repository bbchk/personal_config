local sessionizer = require("custom.sessionizer") -- Adjust path

local M = {}

vim.keymap.set("n", "<leader>fw", function()
    M.add_worktree(sessionizer.refresh_cache)
end, { desc = "Create Git Worktree" })

function M.add_worktree(on_success_callback)
  -- 1. Get the root of the repository
  local repo_root_list = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 or not repo_root_list[1] then
    vim.notify("Not a git repository.", vim.log.levels.ERROR)
    return
  end
  local repo_root = repo_root_list[1]

  -- 2. Verify this is a bare repository managed with worktrees
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

    local dir_name = branch_name:gsub("/", "_")

    -- Check if a directory with that name already exists
    if vim.fn.isdirectory(repo_root .. "/" .. dir_name) == 1 then
      vim.notify(string.format("Worktree directory '%s' already exists.", dir_name), vim.log.levels.ERROR)
      return
    end

    -- 4. Check if the branch exists on the remote 'origin'
    local check_branch_cmd = string.format("git -C '%s' branch -r | grep -q 'origin/%s$'", repo_root, branch_name)
    vim.fn.system(check_branch_cmd)
    local branch_exists_on_remote = (vim.v.shell_error == 0)

    local worktree_cmd
    if branch_exists_on_remote then
      vim.notify(string.format("Branch '%s' found on remote. Creating worktree...", branch_name))
      worktree_cmd = string.format("git -C '%s' worktree add '%s' '%s'", repo_root, dir_name, branch_name)
    else
      vim.notify(string.format("Branch '%s' not found. Creating new local branch and worktree...", branch_name))
      worktree_cmd = string.format("git -C '%s' worktree add -b '%s' '%s'", repo_root, branch_name, dir_name)
    end

    -- 5. Execute the command and trigger the callback on success
    local output = vim.fn.system(worktree_cmd)
    if vim.v.shell_error == 0 then
      vim.notify(string.format("Successfully created worktree '%s'.", dir_name), vim.log.levels.INFO)
      if on_success_callback and type(on_success_callback) == "function" then
        on_success_callback()
      end
    else
      vim.notify(string.format("Failed to create worktree. Error:\n%s", output), vim.log.levels.ERROR)
    end
  end)
end

return M

