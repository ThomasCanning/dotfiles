-- blink.cmp source: completes root-relative paths inside strings, e.g. '/textures/door/color.jpg',
-- from the project's static/ or public/ folder. Vite serves that folder at "/", so the built-in
-- path source (which treats "/" as the filesystem root) can't complete these.

local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source:get_trigger_characters()
  return { "/" }
end

local function public_dir(bufnr)
  local root = vim.fs.root(bufnr, { "package.json", ".git" })
  if not root then
    return nil
  end
  for _, name in ipairs({ "static", "public" }) do
    local dir = root .. "/" .. name
    if vim.fn.isdirectory(dir) == 1 then
      return dir
    end
  end
end

-- the root-relative path typed so far (from an opening quote followed directly by "/"),
-- and the static folder it maps to; nil if this source doesn't apply here
local function typed_path(ctx)
  local before_cursor = ctx.line:sub(1, ctx.cursor[2])
  local typed = before_cursor:match("[\"'`](/[^\"'`]*)$")
  local base = typed and public_dir(ctx.bufnr)
  if base then
    return typed, base
  end
end

-- lets the built-in path source stay quiet where this one takes over
function source.applies(ctx)
  return typed_path(ctx) ~= nil
end

function source:get_completions(ctx, callback)
  local empty = { items = {}, is_incomplete_forward = false, is_incomplete_backward = false }
  local typed, base = typed_path(ctx)
  if not base then
    callback(empty)
    return
  end

  local subdir = typed:match("^(.*/)") -- e.g. "/textures/door/"
  local partial = typed:sub(#subdir + 1) -- what's typed after the last "/"
  local kinds = require("blink.cmp.types").CompletionItemKind
  local row = ctx.cursor[1] - 1
  local range = {
    start = { line = row, character = ctx.cursor[2] - #partial },
    ["end"] = { line = row, character = ctx.cursor[2] },
  }

  local items = {}
  for name, type in vim.fs.dir(base .. subdir) do
    if name:sub(1, 1) ~= "." then
      local is_dir = type == "directory"
      table.insert(items, {
        label = is_dir and name .. "/" or name,
        kind = is_dir and kinds.Folder or kinds.File,
        textEdit = { newText = name, range = range },
      })
    end
  end
  callback({ items = items, is_incomplete_forward = false, is_incomplete_backward = false })
end

return source
