
if vim.g.sessionizer_devcon then
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
