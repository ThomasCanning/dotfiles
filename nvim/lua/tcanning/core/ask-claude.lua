-- :Vi <question> asks Claude Code (via the /vi skill) for the keys to do something,
-- and shows the answer in a floating window.

-- turns markdown table rows into aligned columns; other lines are kept as they are
local function format_tables(lines)
  local rows, out = {}, {}
  local function flush()
    if #rows == 0 then return end
    local widths = {}
    for _, cells in ipairs(rows) do
      for i, cell in ipairs(cells) do
        widths[i] = math.max(widths[i] or 0, vim.fn.strdisplaywidth(cell))
      end
    end
    for r, cells in ipairs(rows) do
      local parts = {}
      for i, cell in ipairs(cells) do
        parts[i] = cell .. string.rep(" ", widths[i] - vim.fn.strdisplaywidth(cell))
      end
      table.insert(out, " " .. table.concat(parts, "   "))
      if r == 1 then
        local rule = {}
        for i, w in ipairs(widths) do rule[i] = string.rep("─", w) end
        table.insert(out, " " .. table.concat(rule, "   "))
      end
    end
    rows = {}
  end

  for _, line in ipairs(lines) do
    if line:match("^%s*|") then
      if not line:match("^%s*|[%s%-:|]+$") then -- skip the |---|---| separator row
        local cells = {}
        for cell in line:gsub("^%s*|", ""):gsub("|%s*$", ""):gmatch("[^|]+") do
          table.insert(cells, vim.trim(cell:gsub("%*%*", ""):gsub("`", "")))
        end
        table.insert(rows, cells)
      end
    else
      flush()
      table.insert(out, line)
    end
  end
  flush()
  return out
end

local function show_answer(text)
  local lines = format_tables(vim.split(vim.trim(text), "\n"))
  local width = 20
  for _, line in ipairs(lines) do
    width = math.max(width, vim.fn.strdisplaywidth(line))
  end
  width = math.min(width, math.floor(vim.o.columns * 0.9))
  local height = math.min(#lines, math.floor(vim.o.lines * 0.8))

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " vi ",
    title_pos = "center",
  })
  vim.wo[win].wrap = true

  for _, key in ipairs({ "q", "<Esc>" }) do
    vim.keymap.set("n", key, function()
      vim.api.nvim_win_close(win, true)
    end, { buffer = buf, nowait = true })
  end
end

local function ask(question)
  if question == nil or vim.trim(question) == "" then
    return
  end
  vim.notify("Asking Claude: " .. question)
  -- runs from the home dir so the answer doesn't depend on the current project
  vim.system({ "claude", "-p", "/vi " .. question }, { text = true, cwd = vim.env.HOME, stdin = "" }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify("Claude failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end
      show_answer(result.stdout)
    end)
  end)
end

vim.api.nvim_create_user_command("Vi", function(opts)
  ask(opts.args)
end, { nargs = "+", desc = "Ask Claude for the Vim keys to do something" })

vim.keymap.set("n", "<leader>?", function()
  vim.ui.input({ prompt = "How do I… " }, ask)
end, { desc = "Ask Claude how to do something in Vim" })
