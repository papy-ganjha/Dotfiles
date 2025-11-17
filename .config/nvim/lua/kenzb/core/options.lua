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
-- Disabled: cursorline + gitsigns causes performance issues on cursor movement
-- opt.cursorline = true

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

-- Performance: Limit shada file size to prevent accumulation
-- '100 = save marks for last 100 files
-- <50 = max 50 lines per register
-- s10 = skip registers larger than 10KB
-- h = disable search highlighting on startup
opt.shada = "!,'100,<50,s10,h"

-- Performance: Reduce update time for better responsiveness
opt.updatetime = 300

-- Remove ':' from indentkeys and cinkeys to prevent auto-indent when typing : in insert mode
vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
  pattern = "*",
  callback = function()
    -- Remove all variations of ':' from indentkeys
    vim.opt_local.indentkeys:remove(":")
    vim.opt_local.indentkeys:remove("<:>")
    vim.opt_local.cinkeys:remove(":")
  end,
})

