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

  -- Fuzzy finder (using Snacks picker)
  -- Telescope removed in favor of snacks.picker

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
    config = function()
      -- Remap C-h/j/k/l in the lazygit terminal buffer to switch tmux panes directly
      -- We bypass vim-tmux-navigator because it navigates neovim windows first,
      -- which moves focus behind the lazygit float
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "*lazygit*",
        callback = function()
          local opts = { buffer = true, silent = true }
          vim.keymap.set("t", "<C-h>", function() vim.fn.system("tmux select-pane -L") end, opts)
          vim.keymap.set("t", "<C-j>", function() vim.fn.system("tmux select-pane -D") end, opts)
          vim.keymap.set("t", "<C-k>", function() vim.fn.system("tmux select-pane -U") end, opts)
          vim.keymap.set("t", "<C-l>", function() vim.fn.system("tmux select-pane -R") end, opts)
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

  -- Claude Code integration
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    opts = {
      terminal = {
        split_side = "right",
        snacks_win_opts = {
          position = "bottom",
          height = 0.3,
          keys = {
            nav_h = { "<C-h>", function()
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateLeft")
            end, mode = "t", desc = "Navigate left" },
            nav_j = { "<C-j>", function()
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateDown")
            end, mode = "t", desc = "Navigate down" },
            nav_k = { "<C-k>", function()
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateUp")
            end, mode = "t", desc = "Navigate up" },
            nav_l = { "<C-l>", function()
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateRight")
            end, mode = "t", desc = "Navigate right" },
          },
        },
      },
    },
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

}
