return {
  -- auto-close (), [], {}, '', "", ``
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    check_ts = true, -- use treesitter, e.g. don't pair ' inside comments/strings
  },
}
