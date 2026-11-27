-- Split a method chain onto separate lines, and join it back:
--   gui.add(mesh.position, 'y').min(-3).max(3)
-- becomes
--   gui.add(mesh.position, 'y')
--     .min(-3)
--     .max(3)
-- Only splits after ")" so property access like `a.b` or `arr[0].x` stays together.

local function split_chain()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local line = vim.api.nvim_get_current_line()
  local indent = line:match("^%s*")
  local child_indent = indent .. string.rep(" ", vim.fn.shiftwidth())

  local parts = vim.split(line, ").", { plain = true })
  if #parts == 1 then
    return
  end
  local lines = { parts[1] .. ")" }
  for i = 2, #parts do
    local suffix = i < #parts and ")" or ""
    table.insert(lines, child_indent .. "." .. parts[i] .. suffix)
  end
  vim.api.nvim_buf_set_lines(0, row - 1, row, false, lines)
end

local function join_chain()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local buf_lines = vim.api.nvim_buf_get_lines(0, row - 1, -1, false)
  local joined = buf_lines[1]
  local count = 1
  -- pull up every following line that starts with "."
  while buf_lines[count + 1] and buf_lines[count + 1]:match("^%s*%.") do
    joined = joined .. vim.trim(buf_lines[count + 1])
    count = count + 1
  end
  vim.api.nvim_buf_set_lines(0, row - 1, row - 1 + count, false, { joined })
end

vim.keymap.set("n", "<leader>ls", split_chain, { desc = "Split method chain onto lines" })
vim.keymap.set("n", "<leader>lj", join_chain, { desc = "Join method chain onto one line" })
