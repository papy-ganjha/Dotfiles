-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load core settings before plugins
require("kenzb.core.options")
require("kenzb.core.keymaps")

-- Setup lazy.nvim
require("lazy").setup("kenzb.plugins", {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})

-- Load colorscheme after plugins
require("kenzb.core.colorscheme")

-- Load plugin configurations
require("kenzb.plugins.comment")
require("kenzb.plugins.nvim-tree")
require("kenzb.plugins.lualine")
require("kenzb.plugins.telescope")
require("kenzb.plugins.nvim-cmp")
require("kenzb.plugins.lsp.mason")
require("kenzb.plugins.lsp.lspsaga")
require("kenzb.plugins.lsp.lspconfig")
require("kenzb.plugins.lsp.null-ls")
require("kenzb.plugins.autopairs")
require("kenzb.plugins.treesitter")
require("kenzb.plugins.gitsigns")
require("kenzb.plugins.distant")
