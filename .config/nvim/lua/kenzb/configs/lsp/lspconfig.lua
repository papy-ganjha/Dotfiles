-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

local goto_status, goto_pckg = pcall(require, "goto-preview")
if not goto_status then
    return
end

local keymap = vim.keymap -- for conciseness

local opts = {}

keymap.set("n", "gf", goto_pckg.goto_preview_references, opts)
keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- got to declaration
keymap.set("n", "gd", goto_pckg.goto_preview_definition, opts)
keymap.set("n", "gi", goto_pckg.goto_preview_implementation, opts) -- go to implementation
keymap.set("n", "gt", goto_pckg.goto_preview_type_definition, opts)
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
