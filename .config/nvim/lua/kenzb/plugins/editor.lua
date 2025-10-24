return {
  -- Essential plugins
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },

  -- Tmux & split window navigation
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
  },

  -- Maximize and restore window
  {
    "szw/vim-maximizer",
    keys = {
      { "<leader>sm", "<cmd>MaximizerToggle<cr>", desc = "Maximize/restore window" },
    },
  },

  -- Surround text objects
  {
    "tpope/vim-surround",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Replace with register
  {
    "inkarkat/vim-ReplaceWithRegister",
    event = { "BufReadPost", "BufNewFile" },
  },

  -- Commenting
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("kenzb.configs.comment")
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    },
    config = function()
      require("kenzb.configs.telescope")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("kenzb.configs.treesitter")
    end,
  },

  -- Git signs
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("kenzb.configs.gitsigns")
    end,
  },

  -- LazyGit
  {
    "kdheepak/lazygit.nvim",
    cmd = "LazyGit",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- Window previews (goto-preview)
  {
    "rmagatti/goto-preview",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("goto-preview").setup({
        width = 120,
        height = 25,
        border = { "↖", "─", "┐", "│", "┘", "─", "└", "│" },
        default_mappings = false,
        debug = false,
        opacity = nil,
        resizing_mappings = false,
        post_open_hook = function(buf, win)
          vim.keymap.set("n", "q", function()
            vim.cmd("q")
          end, { buffer = buf, silent = true })
        end,
      })
    end,
  },

  -- Docstring generation
  {
    "kkoomen/vim-doge",
    build = ":call doge#install()",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>dg", "<cmd>DogeGenerate google<cr>", desc = "Generate docstring" },
    },
  },

  -- Refactoring
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>re", ":Refactor extract ", mode = "x", desc = "Extract" },
      { "<leader>rf", ":Refactor extract_to_file ", mode = "x", desc = "Extract to file" },
      { "<leader>rv", ":Refactor extract_var ", mode = "x", desc = "Extract variable" },
      { "<leader>ri", ":Refactor inline_var", mode = { "n", "x" }, desc = "Inline variable" },
      { "<leader>rI", ":Refactor inline_func", mode = "n", desc = "Inline function" },
      { "<leader>rb", ":Refactor extract_block", mode = "n", desc = "Extract block" },
      { "<leader>rbf", ":Refactor extract_block_to_file", mode = "n", desc = "Extract block to file" },
    },
    config = function()
      require("kenzb.configs.refactoring")
    end,
  },

  -- Distant (for remote editing)
  {
    "chipsenkbeil/distant.nvim",
    branch = "v0.3",
    event = "VeryLazy",
    config = function()
      require("kenzb.configs.distant")
    end,
  },
}
