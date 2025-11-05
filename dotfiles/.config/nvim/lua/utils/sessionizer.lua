local sessionizer_script = vim.fn.expand('~/pers/scripts/sessionizer')

vim.api.nvim_create_user_command('Sessionizer', function()
  local command_to_run = sessionizer_script .. " '" .. vim.v.servername .. "'"

  local terminal_command = "zsh -f -c " .. vim.fn.shellescape(command_to_run)
  vim.cmd('tab terminal ' .. terminal_command)

  vim.cmd('startinsert')
end, {
  desc = "Open the Tmux sessionizer in a full-screen terminal tab"
})
