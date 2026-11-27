return {
  -- fuzzy finder: files, text, shortcuts
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- faster matching
  },
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find file by name" },
    { "<leader>fs", "<cmd>Telescope live_grep<CR>", desc = "Search text in project" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "Search word under cursor" },
    { "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Open buffers" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Search shortcuts" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        file_ignore_patterns = { "node_modules/", "%.git/" },
      },
    })
    telescope.load_extension("fzf")
  end,
}
