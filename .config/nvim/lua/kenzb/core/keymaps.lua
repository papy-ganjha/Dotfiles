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
