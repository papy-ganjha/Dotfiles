return {
  -- Theme selector (configured in core/colorscheme.lua)
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Auto-switch light/dark with macOS appearance
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1001,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.api.nvim_set_option_value("background", "dark", {})
        vim.cmd.colorscheme("catppuccin-mocha")
      end,
      set_light_mode = function()
        vim.api.nvim_set_option_value("background", "light", {})
        vim.cmd.colorscheme("catppuccin-latte")
      end,
    },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
  },
}
