return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig", -- provides the server configs
      "saghen/blink.cmp",
    },
    config = function()
      -- tell every LSP server what the completion plugin can do
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      -- installs these servers automatically and enables them
      require("mason-lspconfig").setup({
        ensure_installed = { "emmet_language_server", "ts_ls" },
        automatic_enable = true,
      })
    end,
  },
}
