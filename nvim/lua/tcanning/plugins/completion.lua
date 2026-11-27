return {
  "saghen/blink.cmp",
  version = "1.*", -- release tags ship a prebuilt binary
  event = "InsertEnter",
  opts = {
    -- <C-space> open menu, <C-n>/<C-p> or Up/Down to move,
    -- <CR> to accept, <C-e> to close
    keymap = {
      preset = "enter",
      -- Tab: accept suggestion if menu is open, else jump to next snippet spot, else normal tab
      ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
    },
    completion = {
      documentation = { auto_show = true },
    },
    sources = {
      default = { "lsp", "path", "buffer" },
    },
  },
}
