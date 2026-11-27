return {
  "mattn/emmet-vim",
  ft = { "html", "css", "scss", "sass", "less", "javascriptreact", "typescriptreact", "vue", "svelte", "astro", "xml" },
  init = function()
    -- only enable in insert mode, and only for the filetypes above
    vim.g.user_emmet_mode = "i"
    vim.g.user_emmet_install_global = 0
    -- expand with <C-y>, (default leader is <C-y>)
    vim.g.user_emmet_leader_key = "<C-y>"
    -- use className etc. in JSX/TSX
    vim.g.user_emmet_settings = {
      javascriptreact = { extends = "jsx" },
      typescriptreact = { extends = "tsx" },
    }
  end,
  config = function()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "html", "css", "scss", "sass", "less", "javascriptreact", "typescriptreact", "vue", "svelte", "astro", "xml" },
      callback = function()
        vim.cmd("EmmetInstall")
      end,
    })
    -- the plugin loads on FileType, so install for the buffer that triggered it
    vim.cmd("EmmetInstall")
  end,
}
