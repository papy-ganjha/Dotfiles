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

-- Remove soft wraps from text yanked in terminal buffers
-- IMPORTANT: must register BEFORE the OSC52 clipboard autocmd so it runs first
-- and the modified register is what gets sent to the system clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    if vim.bo.buftype ~= "terminal" then return end
    if vim.v.event.operator ~= "y" then return end
    local regname = vim.v.event.regname == "" and '"' or vim.v.event.regname
    local content = vim.fn.getreg(regname)
    if not content or content == "" then return end
    local lines = vim.split(content, "\n", { plain = true })
    if lines[#lines] == "" then table.remove(lines) end
    if #lines < 2 then return end
    local max_len = 0
    for _, line in ipairs(lines) do
      max_len = math.max(max_len, vim.fn.strdisplaywidth(line))
    end
    if max_len < 40 then return end
    -- Use 85% of max as threshold — terminal wraps can land at slightly different
    -- column positions due to wide chars, but they're all "long" lines
    local threshold = math.floor(max_len * 0.85)
    local merged = { lines[1] }
    for i = 2, #lines do
      local prev = merged[#merged]
      local prev_len = vim.fn.strdisplaywidth(prev)
      local last_char = prev:sub(-1)
      -- Treat as soft wrap if: previous line is "long enough" AND doesn't end
      -- with natural sentence/paragraph punctuation
      local is_soft_wrap = prev_len >= threshold
        and last_char ~= "." and last_char ~= "!" and last_char ~= "?"
        and last_char ~= " "
      if is_soft_wrap then
        merged[#merged] = prev .. lines[i]
      else
        table.insert(merged, lines[i])
      end
    end
    local result = table.concat(merged, "\n")
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

