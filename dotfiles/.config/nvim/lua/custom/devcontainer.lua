
if vim.g.sessionizer_devcon then
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        once = true,
        callback = function()
            local folder = vim.g.sessionizer_folder
            local has_folder = type(folder) == "string" and folder ~= ""
            -- cd first so the terminal tab and Telescope find_files both default to it.
            if has_folder then
                vim.cmd("cd " .. vim.fn.fnameescape(folder))
            end
            vim.cmd([[
                terminal
                tabnew
            ]])
            vim.defer_fn(function()
                if has_folder then
                    vim.cmd("Oil " .. vim.fn.fnameescape(folder))
                else
                    vim.cmd("Oil")
                end
                vim.cmd("Telescope find_files")
            end, 50)
        end,
    })
end
