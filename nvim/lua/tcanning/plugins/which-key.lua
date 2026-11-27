return {
  -- pops up the available keys after you press the start of a shortcut
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300, -- ms to wait before showing the popup
    spec = {
      -- group names shown in the popup
      { "<leader>c", group = "comment" },
      { "<leader>d", group = "diagnostics" },
      { "<leader>e", group = "explorer" },
      { "<leader>f", group = "find" },
      { "<leader>l", group = "code (LSP)" },
      { "<leader>n", group = "no highlight" },
    },
  },
}
