if vim.env.SESSIONIZER_START == "true" then
  vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    once = true,
    callback = function()

      vim.cmd("terminal")
      vim.cmd("tabnew")

      vim.defer_fn(function()
        vim.cmd("Oil")
        vim.cmd("Telescope find_files")
      end, 50) -- 50ms delay is a safe bet
    end,
  })
end
