return {
  -- Auto completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
    config = function()
      require("kenzb.configs.nvim-cmp")
    end,
  },

  -- Snippets
  {
    "L3MON4D3/LuaSnip",
    lazy = true,
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("kenzb.configs.autopairs")
    end,
  },
}
