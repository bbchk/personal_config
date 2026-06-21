return {
  "williamboman/mason.nvim",
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    require("mason").setup({
      log_level = vim.log.levels.WARN,
    })

    require("mason-lspconfig").setup({
      automatic_installation = false,
      ensure_installed = {
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "eslint",
        "html",
        "intelephense",
        "jsonls",
        "pyright",
        "ruby_lsp",
        "sqlls",
        "stylelint_lsp",
        "tailwindcss",
        "ts_ls",
        "jdtls",
      },
    })

    require("mason-tool-installer").setup({
      automatic_installation = false,
      ensure_installed = {
        "black",
        "clang-format",
        "eslint_d",
        "isort",
        "js-debug-adapter",
        "markdownlint",
        "php-cs-fixer",
        "php-debug-adapter",
        "prettier",
        "rubocop",
        "shfmt",
        "stylua",
      },
    })
  end,
}

