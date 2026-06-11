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

-- :terminal buffers keep each program-emitted line as a single buffer line.
-- With wrap on, long lines fold visually but yank/V still operate on the
-- whole logical line — no soft-wrap merging needed.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})

-- Soft-wrap merge for :terminal yanks — narrowly scoped.
-- Only triggers on a line-wise visual yank (V then y) inside a :terminal
-- buffer. Normal-mode yanks, char-wise yanks, and yanks from any other
-- buffer are untouched. Heuristic: a row is treated as wrapped only when
-- its display width fills the terminal column count (within 1 col for
-- wide-char rounding). If no row in the selection is "short", we bail —
-- that's the signature of tabular output where every row happens to be
-- full-width and merging would be wrong.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.bo.buftype ~= "terminal" then return end
    local ev = vim.v.event
    if ev.operator ~= "y" then return end
    if not ev.visual then return end
    if (ev.regtype or ""):sub(1, 1) ~= "V" then return end

    local regname = ev.regname == "" and '"' or ev.regname
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
    local threshold = term_width - 1

    -- Bail if every row is full-width: looks like tabular output, not wraps.
    local has_short = false
    for _, line in ipairs(lines) do
      if vim.fn.strdisplaywidth(line) < threshold then
        has_short = true
        break
      end
    end
    if not has_short then return end

    local merged = { lines[1] }
    for i = 2, #lines do
      -- Decide based on the ORIGINAL previous line, not the accumulating
      -- merged one — otherwise consecutive wraps cascade incorrectly.
      if vim.fn.strdisplaywidth(lines[i - 1]) >= threshold then
        merged[#merged] = merged[#merged] .. lines[i]
      else
        table.insert(merged, lines[i])
      end
    end

    local result = table.concat(merged, "\n")
    if trailing_nl then result = result .. "\n" end
    vim.fn.setreg(regname, result, "V")
    if regname == '"' then vim.fn.setreg("+", result, "V") end
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

