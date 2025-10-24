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

-- Auto-open NvimTree on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Only open if no file was specified
    if vim.fn.argc() == 0 then
      -- Small delay to ensure nvim-tree is fully loaded
      vim.defer_fn(function()
        vim.cmd("NvimTreeOpen")
      end, 10)
    end
  end,
})
