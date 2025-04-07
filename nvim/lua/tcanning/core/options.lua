-- use tree folder structure
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- show relative numbers in buffer
opt.relativenumber = true
opt.number = true

-- tabs and indentation
opt.tabstop    = 2
opt.shiftwidth = 2
opt.expandtab  = true
opt.autoindent = true

-- search settings
opt.ignorecase = true 
opt.smartcase  = true

opt.cursorline = true

-- appearance
opt.termguicolors = true
opt.background    = "dark"
opt.signcolumn    = "yes"

-- backspace
opt.backspace = "indent,eol,start" --allows backspace on indent, end of line, or inster mode start position

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitright = true
opt.splitbelow = true
