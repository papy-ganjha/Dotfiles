return {
  -- Theme selector
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("themery").setup({
        themes = { "gruvbox", "catppuccin", "tokyonight" },
        livePreview = true,
      })
    end,
  },

  -- Catppuccin theme
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
  },

  -- Tokyonight theme
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Gruvbox theme
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
  },
}
