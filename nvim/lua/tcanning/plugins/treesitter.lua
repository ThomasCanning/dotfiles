local languages = {
  "html", "css", "javascript", "typescript", "tsx",
  "json", "lua", "vim", "vimdoc", "markdown", "markdown_inline",
  "vue", "svelte", "astro", "xml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- builds parsers for these languages (skips ones already installed)
      require("nvim-treesitter").install(languages)

      -- turn on treesitter colouring and indenting for files with a parser
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    -- auto-close and auto-rename HTML/JSX tags
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
