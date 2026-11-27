vim.g.mapleader = " "
local keymap = vim.keymap
keymap.set("i","jk","<ESC>", {desc = "Exit insert mode with jk"})
keymap.set("n", "<leader>nh", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })



-- Cmd-Z / Cmd-Y undo & redo. iTerm is set to send Cmd-Z as Alt-z (<M-z>)
-- and Cmd-Y as Alt-y (<M-y>), because macOS doesn't pass Cmd keys to terminal apps.
keymap.set("i", "<M-z>", "<C-o>u", { desc = "Undo (Cmd-Z)" })
keymap.set("i", "<M-y>", "<C-o><C-r>", { desc = "Redo (Cmd-Y)" })
keymap.set("n", "<M-z>", "u", { desc = "Undo (Cmd-Z)" })
keymap.set("v", "<M-z>", "<Esc>u", { desc = "Undo (Cmd-Z)" })
keymap.set("n", "<M-y>", "<C-r>", { desc = "Redo (Cmd-Y)" })
keymap.set("v", "<M-y>", "<Esc><C-r>", { desc = "Redo (Cmd-Y)" })

-- Cmd-S save. iTerm is set to send Cmd-S as Alt-s (<M-s>). Stays in the current mode.
keymap.set({ "n", "i", "v" }, "<M-s>", "<Cmd>write<CR>", { desc = "Save (Cmd-S)" })

-- Cmd-A select all. iTerm is set to send Cmd-A as Alt-a (<M-a>).
keymap.set({ "n", "v" }, "<M-a>", "<Esc>ggVG", { desc = "Select all (Cmd-A)" })
keymap.set("i", "<M-a>", "<Esc>ggVG", { desc = "Select all (Cmd-A)" })

-- Backspace on a selection deletes it and starts insert mode, like other editors.
-- "_ keeps the deleted text out of the clipboard.
keymap.set("x", "<BS>", '"_c', { desc = "Delete selection" })

-- start a new undo step at every space, so Cmd-Z in insert mode undoes word by word
keymap.set("i", "<Space>", "<C-g>u<Space>", { desc = "Space with undo break" })

-- comments (uses nvim's built-in gc)
keymap.set("n", "<leader>cc", "gcc", { remap = true, desc = "Comment line" })
keymap.set("n", "<leader>cb", "gcip", { remap = true, desc = "Comment block (up to blank lines)" })
keymap.set("v", "<leader>c", "gc", { remap = true, desc = "Comment selection" })

-- diagnostics (errors / warnings / hints)
keymap.set("n", "<leader>dd", vim.diagnostic.open_float, { desc = "Show message on line" })
keymap.set("n", "<leader>dn", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next diagnostic" })
keymap.set("n", "<leader>dp", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous diagnostic" })
keymap.set("n", "<leader>dl", function()
  -- close the list if it's open, otherwise fill it with diagnostics and open it
  if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
    vim.cmd("cclose")
  else
    vim.diagnostic.setqflist()
  end
end, { desc = "Toggle list of all diagnostics" })

-- code navigation (language server)
keymap.set("n", "<leader>ld", vim.lsp.buf.definition, { desc = "Go to definition" })
keymap.set("n", "<leader>lr", vim.lsp.buf.references, { desc = "Find references" })
keymap.set("n", "<leader>ln", vim.lsp.buf.rename, { desc = "Rename everywhere" })
keymap.set("n", "<leader>lk", vim.lsp.buf.hover, { desc = "Show docs" })
keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { desc = "Quick fix / add import" })

-- mouse drag copies the selection to the Mac clipboard (and keeps it selected)
keymap.set("v", "<LeftRelease>", "ygv", { desc = "Copy mouse selection" })
