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

-- Wrap long lines visually inside :terminal buffers so output stays readable
-- without horizontal scrolling.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Strip soft-wrap breaks from text yanked in :terminal buffers. A buffer line
-- that ended with a real \n is shorter than the terminal column count;
-- libvterm only fills the row exactly when it had to wrap. So: merge a line
-- into the next iff its display width equals the terminal width.
-- Must run BEFORE the OSC52 autocmd below so the system clipboard sees the
-- merged register.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.bo.buftype ~= "terminal" then return end
    if vim.v.event.operator ~= "y" then return end
    local regname = vim.v.event.regname == "" and '"' or vim.v.event.regname
    local content = vim.fn.getreg(regname)
    if not content or content == "" then return end
    local lines = vim.split(content, "\n", { plain = true })
    local trailing_nl = lines[#lines] == ""
    if trailing_nl then table.remove(lines) end
    if #lines < 2 then return end
    local win = vim.api.nvim_get_current_win()
    local info = vim.fn.getwininfo(win)[1]
    local term_width = vim.api.nvim_win_get_width(win) - (info and info.textoff or 0)
    if term_width < 1 then return end
    local merged = { lines[1] }
    for i = 2, #lines do
      local prev = merged[#merged]
      if vim.fn.strdisplaywidth(prev) >= term_width then
        merged[#merged] = prev .. lines[i]
      else
        table.insert(merged, lines[i])
      end
    end
    local result = table.concat(merged, "\n")
    if trailing_nl then result = result .. "\n" end
    vim.fn.setreg(regname, result, "v")
    if regname == '"' then
      vim.fn.setreg("+", result, "v")
    end
  end,
})

-- OSC 52 clipboard: yank to terminal clipboard via tmux client tty (works over mosh/ssh)
if os.getenv('TMUX') then
  vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
      if vim.v.event.operator == 'y' then
        vim.fn.system(
          'yank > "$(tmux display-message -p \'#{client_tty}\' 2>/dev/null || echo /dev/tty)"',
          vim.fn.getreg('"')
        )
      end
    end,
  })
end

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

-- Auto-activate Python venv when .venv exists in cwd (only if no env is already active)
-- Runs synchronously so LSP config picks it up
if not vim.env.VIRTUAL_ENV and not vim.env.CONDA_DEFAULT_ENV then
  local cwd = vim.fn.getcwd()
  local venv = cwd .. "/.venv"
  if vim.fn.isdirectory(venv) == 1 then
    local python = venv .. "/bin/python"
    if vim.fn.executable(python) == 1 then
      vim.env.VIRTUAL_ENV = venv
      vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
      vim.g.python3_host_prog = python
    end
  end
end

