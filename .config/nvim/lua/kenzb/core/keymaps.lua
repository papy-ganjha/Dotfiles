vim.g.mapleader = " " -- Master key is space now!

local keymap = vim.keymap -- for conciseness

-- general keymaps
keymap.set("i", "jk", "<ESC>")
keymap.set("n", "<leader>nh", ":nohl<CR>") -- no highlights

-- Save easily file
keymap.set("n", "<leader>w", ":w<CR>")

-- Increment and decrement numbers
keymap.set("n", "<leader>+", "<C-a>")
keymap.set("n", "<leader>-", "<C-x>")

-- Windows management
keymap.set("n", "<leader>sv", "<C-w>v") -- split vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make split windows same width
keymap.set("n", "<leader>sx", ":close<CR>") -- split exit

-- Tabs management
keymap.set("n", "<leader>to", ":tabnew<CR>") -- open a new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") -- close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") -- next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") -- previous tab

-- Terminal mode: tmux-style pane navigation
keymap.set("t", "<C-h>", [[<C-\><C-n><cmd>TmuxNavigateLeft<cr>]], { silent = true })
keymap.set("t", "<C-j>", [[<C-\><C-n><cmd>TmuxNavigateDown<cr>]], { silent = true })
keymap.set("t", "<C-k>", [[<C-\><C-n><cmd>TmuxNavigateUp<cr>]], { silent = true })
keymap.set("t", "<C-l>", [[<C-\><C-n><cmd>TmuxNavigateRight<cr>]], { silent = true })

-- In terminal buffers, V auto-extends across soft-wrapped lines so a single press
-- selects the whole logical line. The yank autocmd in options.lua then strips the
-- soft-wrap newlines on copy, so the result pastes as one line.
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function(ev)
    vim.keymap.set("n", "V", function()
      local cur = vim.api.nvim_win_get_cursor(0)[1]
      local total = vim.api.nvim_buf_line_count(0)
      local lines = vim.api.nvim_buf_get_lines(0, 0, total, false)
      local function looks_wrapped(line)
        if not line then return false end
        if #line < 80 then return false end
        local last = line:sub(-1)
        return last ~= "." and last ~= "!" and last ~= "?" and last ~= " "
      end
      local start_line = cur
      while start_line > 1 and looks_wrapped(lines[start_line - 1]) do
        start_line = start_line - 1
      end
      local end_line = cur
      while end_line < total and looks_wrapped(lines[end_line]) do
        end_line = end_line + 1
      end
      vim.api.nvim_win_set_cursor(0, { start_line, 0 })
      vim.cmd("normal! V")
      if end_line > start_line then
        vim.api.nvim_win_set_cursor(0, { end_line, 0 })
      end
    end, { buffer = ev.buf, desc = "Visual-line, auto-extend across wraps" })
  end,
})
