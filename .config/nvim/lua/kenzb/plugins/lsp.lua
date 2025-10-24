return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- Mason: LSP server manager
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
  },

  -- Mason LSP config
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
  },

  -- Mason null-ls bridge
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
  },

  -- Null-ls for formatting and linting
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- LSP UI enhancements
  {
    "glepnir/lspsaga.nvim",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },

  -- LSP kind icons
  {
    "onsails/lspkind.nvim",
    lazy = true,
  },

  -- Pylance support
  {
    "lithammer/nvim-pylance",
    event = { "BufReadPost", "BufNewFile" },
    ft = "python",
  },
}
