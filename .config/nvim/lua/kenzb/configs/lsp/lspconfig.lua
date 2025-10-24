-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local keymap = vim.keymap -- for conciseness

local opts = {}

-- Helper function to create a floating window handler for LSP functions
local function make_floating_handler(method)
  return function()
    -- Save the window we're calling from
    local source_win = vim.api.nvim_get_current_win()

    local params = vim.lsp.util.make_position_params()

    vim.lsp.buf_request(0, method, params, function(err, result, ctx, config)
      if err then
        vim.notify("Error: " .. tostring(err), vim.log.levels.ERROR)
        return
      end

      if not result or vim.tbl_isempty(result) then
        vim.notify("No " .. method .. " found", vim.log.levels.WARN)
        return
      end

      -- Handle both single result and array of results
      local location = result
      if vim.tbl_islist(result) then
        location = result[1]
      end

      -- Extract the target URI and range
      local uri = location.uri or location.targetUri
      local range = location.range or location.targetRange

      -- Open the file in a new buffer
      local bufnr = vim.uri_to_bufnr(uri)
      vim.fn.bufload(bufnr)

      -- Calculate floating window size (60% of editor size)
      local width = math.floor(vim.o.columns * 0.6)
      local height = math.floor(vim.o.lines * 0.6)

      -- Calculate position to center the window
      local row = math.floor((vim.o.lines - height) / 2)
      local col = math.floor((vim.o.columns - width) / 2)

      -- Create the floating window
      local win = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        row = row,
        col = col,
        style = "minimal",
        border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      })

      -- Set window-local options
      vim.api.nvim_win_set_option(win, 'winblend', 0)

      -- Jump to the correct position in the buffer
      if range then
        local line = range.start.line + 1
        local character = range.start.character
        vim.api.nvim_win_set_cursor(win, {line, character})
        -- Center the view on the cursor
        vim.cmd("normal! zz")
      end

      -- Add keybinding to close the floating window with 'q' and return to source window
      vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(0, true)
        -- Return focus to the source window if it's still valid
        if vim.api.nvim_win_is_valid(source_win) then
          vim.api.nvim_set_current_win(source_win)
        end
      end, { buffer = bufnr, noremap = true, silent = true })
    end)
  end
end

keymap.set("n", "gf", vim.lsp.buf.references, opts) -- show references
keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration
keymap.set("n", "gd", make_floating_handler("textDocument/definition"), opts) -- go to definition in floating window
keymap.set("n", "gi", make_floating_handler("textDocument/implementation"), opts) -- go to implementation in floating window
keymap.set("n", "gt", make_floating_handler("textDocument/typeDefinition"), opts) -- go to type definition in floating window
keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
-- keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
keymap.set("n", "<leader>rn", vim.lsp.buf.rename , opts) -- smart rename
keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side


-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end
