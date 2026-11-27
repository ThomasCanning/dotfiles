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
      default = { "lsp", "path", "static_paths", "buffer" },
      providers = (function()
        -- inside a '/...' static path, only the static_paths source shows suggestions
        local function not_static_path(ctx)
          return not require("tcanning.blink-static-paths").applies(ctx)
        end
        return {
          static_paths = { name = "Static", module = "tcanning.blink-static-paths" },
          lsp = { should_show_items = not_static_path },
          path = { should_show_items = not_static_path },
          buffer = { should_show_items = not_static_path },
        }
      end)(),
    },
  },
}
