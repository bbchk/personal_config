return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    -- Only install tooling for toolchains present in this container. See core/langs.lua.
    local langs = require("core.langs")

    require("mason").setup({
      log_level = vim.log.levels.WARN,
    })

    require("mason-lspconfig").setup({
      automatic_installation = false,
      ensure_installed = langs.servers(),
    })

    require("mason-tool-installer").setup({
      automatic_installation = false,
      ensure_installed = langs.mason_tools(),
    })
  end,
}

