return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "folke/neodev.nvim", opts = {} },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Setup mason first
    require("mason").setup()
    require("mason-lspconfig").setup()

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
      end,
    })

    local servers_by_filetype = {
      -- CSS
      css  = "cssls",
      scss = "cssls",
      less = "cssls",

      -- Web
      html             = { "html", "tailwindcss" },
      javascript       = { "eslint", "ts_ls" },
      typescript       = { "eslint", "ts_ls" },
      javascriptreact  = { "eslint", "ts_ls" },
      typescriptreact  = { "eslint", "ts_ls" },
      svelte           = { "eslint", "ts_ls" },
      vue              = { "eslint", "ts_ls" },
      ["html.twig"]    = "tailwindcss",

      -- JSON
      json  = "jsonls",
      jsonc = "jsonls",

      -- Python
      python = "pyright",

      -- Ruby
      ruby = "ruby_lsp",

      -- PHP
      php = "intelephense",

      -- Go
      go = "gopls",

      -- Lua
      lua = "lua_ls",

      -- SQL
      sql = "sqlls",
    }

    -- Invert the map: server -> list of filetypes
    local server_filetypes = {}
    for ft, servers in pairs(servers_by_filetype) do
      if type(servers) == "string" then
        servers = { servers }
      end
      for _, server in ipairs(servers) do
        if not server_filetypes[server] then
          server_filetypes[server] = {}
        end
        table.insert(server_filetypes[server], ft)
      end
    end

    -- Configure each server with its filetypes, then enable it
    for server, filetypes in pairs(server_filetypes) do
      vim.lsp.config(server, { filetypes = filetypes })
      vim.lsp.enable(server)
    end
  end,
}
