local sessionizer_script = vim.fn.expand('~/pers/scripts/sessionizer') -- Adjust if your path is different

-- Create the :Sessionizer user command
vim.api.nvim_create_user_command('Sessionizer', function()
  -- This command string will be executed in a new terminal
  -- 1. It runs your script.
  -- 2. After your script finishes (either by selecting a session or cancelling),
  --    it runs 'exit', which closes the shell and thus the terminal tab.
  local c = sessionizer_script .. " '" .. vim.v.servername .. "';"

  -- Open a new terminal in a new tab and run the command

  vim.cmd.new()
	vim.cmd.wincmd("J")
	vim.api.nvim_win_set_height(0, 20)
	vim.wo.winfixheight = true
  vim.cmd('terminal ' .. c)

  vim.cmd('startinsert')
  -- vim.cmd('close')
end, {
  desc = "Open the Tmux sessionizer in a new terminal tab"
})
