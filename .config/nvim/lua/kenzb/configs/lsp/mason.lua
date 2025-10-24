-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
  return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
  return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
  return
end

-- enable mason
mason.setup()

mason_lspconfig.setup({
  -- list of servers for mason to install
  ensure_installed = {
    "pyright",
  },
  -- auto-install configured servers (with lspconfig)
  automatic_installation = true, -- not the same as ensure_installed
})

-- Use the new vim.lsp.config API instead of lspconfig
local lspconfig = vim.lsp.config

-- Get capabilities from cmp-nvim-lsp
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_nvim_lsp_status and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Configure pyright LSP server
lspconfig.pyright = {
  filetypes = { "python" },
  capabilities = capabilities,
  settings = {
    python = {
      pythonPath = vim.fn.exepath("python"),
      analysis = {
        -- Enable auto-import completions for symbols not yet imported
        autoImportCompletions = true,
        -- Enable background indexing of the entire workspace
        indexing = true,
        -- Analyze the entire workspace, not just open files
        diagnosticMode = "workspace",
        -- Enable auto-search for Python paths
        autoSearchPaths = true,
        -- Use library code for completions
        useLibraryCodeForTypes = true,
        -- Configure how deeply to index packages
        packageIndexDepths = {
          {
            name = "",  -- empty string means workspace root
            depth = 10, -- index up to 10 levels deep
            includeAllSymbols = true,
          },
        },
        -- Type checking mode
        typeCheckingMode = "basic",
      }
    }
  },
  root_dir = function(bufnr, on_dir)
    on_dir(vim.fs.root(bufnr, { ".git", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile" }))
  end,
}

mason_null_ls.setup({
  -- list of formatters & linters for mason to install
  ensure_installed = {
    "stylua", -- lua formatter
  },
  -- auto-install configured formatters & linters (with null-ls)
  automatic_installation = true,
})
