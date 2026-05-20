return {
  -- Snacks (multi-purpose utilities)
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = false },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = false },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file explorer" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fs", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep word" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
    },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("kenzb.configs.lualine")
    end,
  },
}
