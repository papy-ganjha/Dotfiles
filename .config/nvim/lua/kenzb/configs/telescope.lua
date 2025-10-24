-- import telescope plugin safely
local telescope_setup, telescope = pcall(require, "telescope")
if not telescope_setup then
  return
end

-- import telescope actions safely
local actions_setup, actions = pcall(require, "telescope.actions")
if not actions_setup then
  return
end

-- import telescope actions safely
local action_state_setup, action_state = pcall(require, "telescope.actions.state")
if not action_state_setup then
  return
end

-- configure telescope
telescope.setup({
  -- configure custom mappings
  defaults = {
      layout_config = {
      -- Opens in a centered floating window
      horizontal = {
        preview_width = 0.6,
        width = 0.8,
        height = 0.8,
        preview_cutoff = 1,
      },
      vertical = {
        preview_height = 0.5,
        height = 0.9,
        width = 0.8,
      },
    },
    -- Default layout strategy: "horizontal" (floating) or "vertical"
    layout_strategy = "vertical", -- or "horizontal"
  },
  pickers = {
    lsp_definitions = {
      -- Force floating window for definitions
      layout_config = {
        anchor = "center",
        width = 0.8,
        height = 0.8,
        preview_cutoff = 1,
      },
      layout_strategy = "center", -- "vertical", "horizontal", or "center"
    },
    mappings = {
      i = {
        -- Open selected file in floating window
        ["<CR>"] = function(prompt_bufnr)
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)  -- Close Telescope

          -- Create floating window
          local buf = vim.api.nvim_create_buf(false, true)  -- Create new buffer
          vim.api.nvim_buf_set_name(buf, entry.filename)    -- Set filename
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(entry.filename))  -- Load content

          -- Window settings
          local width = math.floor(vim.o.columns * 0.8)
          local height = math.floor(vim.o.lines * 0.8)
          local opts = {
            relative = "editor",
            width = width,
            height = height,
            col = (vim.o.columns - width) / 2,
            row = (vim.o.lines - height) / 2,
            style = "minimal",
            border = "rounded",
          }

          -- Open floating window
          local win = vim.api.nvim_open_win(buf, true, opts)
          vim.api.nvim_win_set_cursor(win, {entry.lnum, entry.col})
          vim.api.nvim_buf_set_option(buf, "buftype", "")  -- Make buffer editable
        end,
        ["<C-k>"] = actions.move_selection_previous, -- move to prev result
        ["<C-j>"] = actions.move_selection_next, -- move to next result
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
      },
    },
  },
})

telescope.load_extension("fzf")
