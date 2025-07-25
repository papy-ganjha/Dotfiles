local opt = vim.opt -- for conciseness

-- line numbers
opt.relativenumber = true
opt.number = true

-- tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true

-- Set minimal number of lines to keep above and below the cursor (e.g., 5 lines)
vim.opt.scrolloff = 10

-- line wrapping
opt.wrap = false

-- search settings
opt.ignorecase = true
opt.smartcase = true

-- cursor line
opt.cursorline = true

-- appareance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"

-- backspace
opt.backspace = "indent,eol,start"
opt.clipboard:append("unnamedplus")  -- use system clipboard with vim  operations

-- split windows
opt.splitright = true
opt.splitbelow = true

opt.iskeyword:append("-") -- consider it as part of a word

