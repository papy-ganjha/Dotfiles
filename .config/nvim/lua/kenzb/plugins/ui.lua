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
      explorer = {
        enabled = true,
      },
      indent = { enabled = false },
      input = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            win = {
              list = {
                keys = {
                  ["<c-h>"] = false,
                  ["<c-j>"] = false,
                  ["<c-k>"] = false,
                  ["<c-l>"] = false,
                },
              },
            },
          },
        },
      },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      image = { enabled = false },
      styles = {
        terminal = {
          keys = {
            nav_h = { "<C-h>", function()
              if vim.g.claude_maximized then
                vim.g.claude_maximized = false
                vim.cmd("wincmd =")
                local total = vim.o.lines
                vim.api.nvim_win_set_height(0, math.floor(total * 0.3))
              end
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateLeft")
            end, mode = "t", desc = "Navigate left" },
            nav_j = { "<C-j>", function()
              if vim.g.claude_maximized then
                vim.g.claude_maximized = false
                vim.cmd("wincmd =")
                local total = vim.o.lines
                vim.api.nvim_win_set_height(0, math.floor(total * 0.3))
              end
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateDown")
            end, mode = "t", desc = "Navigate down" },
            nav_k = { "<C-k>", function()
              if vim.g.claude_maximized then
                vim.g.claude_maximized = false
                vim.cmd("wincmd =")
                local total = vim.o.lines
                vim.api.nvim_win_set_height(0, math.floor(total * 0.3))
              end
              vim.cmd("stopinsert")
              vim.cmd("wincmd p")
            end, mode = "t", desc = "Navigate to previous window" },
            nav_l = { "<C-l>", function()
              if vim.g.claude_maximized then
                vim.g.claude_maximized = false
                vim.cmd("wincmd =")
                local total = vim.o.lines
                vim.api.nvim_win_set_height(0, math.floor(total * 0.3))
              end
              vim.cmd("stopinsert")
              vim.cmd("TmuxNavigateRight")
            end, mode = "t", desc = "Navigate right" },
          },
        },
      },
    },
    keys = {
      { "<leader>e", function() Snacks.explorer() end, desc = "Toggle file explorer" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
      { "<leader>fs", function() Snacks.picker.grep() end, desc = "Live grep" },
      { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Grep word" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help tags" },
      { "<leader>ta", function()
        for _, t in ipairs(Snacks.terminal.list()) do
          if t:win_valid() then t:hide() end
        end
        local ok, claude_term = pcall(require, "claudecode.terminal")
        if ok then
          local claude_buf = claude_term.get_active_terminal_bufnr()
          if claude_buf then
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == claude_buf then
                vim.api.nvim_win_close(win, false)
              end
            end
          end
        end
        Snacks.terminal.open(nil, { count = vim.fn.reltimefloat(vim.fn.reltime()) * 1000 })
      end, desc = "New terminal" },
      { "<leader>tg", function() Snacks.terminal.toggle() end, desc = "Toggle terminal" },
      { "<leader>tv", function()
        local visible_term
        for _, t in ipairs(Snacks.terminal.list()) do
          if t:win_valid() then
            visible_term = t
            break
          end
        end
        if visible_term then
          vim.api.nvim_set_current_win(visible_term.win)
          vim.cmd("vsplit")
          vim.cmd("terminal")
          vim.cmd("startinsert")
        else
          Snacks.terminal.open(nil, {
            count = vim.fn.reltimefloat(vim.fn.reltime()) * 1000,
          })
        end
      end, desc = "New terminal (side)" },
      { "<leader>tl", function()
        local terms = Snacks.terminal.list()
        if #terms == 0 then
          vim.notify("No terminals open", vim.log.levels.INFO)
          return
        end
        vim.ui.select(terms, {
          prompt = "Select terminal",
          format_item = function(t)
            local label_parts = {}
            local chan = vim.bo[t.buf].channel
            local pid
            if chan and chan > 0 then
              local ok, p = pcall(vim.fn.jobpid, chan)
              if ok and p > 0 then pid = p end
            end
            -- Get cwd via the terminal job's pid
            if pid then
              local out = vim.fn.system("lsof -a -d cwd -p " .. pid .. " -Fn 2>/dev/null | tail -1")
              local cwd = out:match("^n(.+)$") or out:match("^n(.-)\n")
              if cwd then
                table.insert(label_parts, vim.fn.fnamemodify(cwd, ":~"))
              end
            end
            -- Get the running child command, or fall back to last command from buffer
            local cmd
            if pid then
              local children = vim.fn.system("pgrep -P " .. pid .. " 2>/dev/null"):gsub("%s+$", "")
              if children ~= "" then
                local first_child = children:match("^(%d+)")
                cmd = vim.fn.system("ps -p " .. first_child .. " -o command= 2>/dev/null"):gsub("\n", "")
                cmd = vim.trim(cmd)
              end
            end
            if not cmd or cmd == "" then
              -- Idle: scan buffer for last command (line containing a prompt char)
              local lines = vim.api.nvim_buf_get_lines(t.buf, -50, -1, false)
              for i = #lines, 1, -1 do
                local line = lines[i]
                local after_prompt = line:match("[❯$%%>]%s+(.+)$")
                if after_prompt and vim.trim(after_prompt) ~= "" then
                  cmd = "(idle) " .. vim.trim(after_prompt):sub(1, 60)
                  break
                end
              end
            end
            if cmd and cmd ~= "" then
              table.insert(label_parts, cmd:sub(1, 60))
            end
            local label = #label_parts > 0 and table.concat(label_parts, "  │  ")
              or vim.api.nvim_buf_get_name(t.buf)
            return string.format("[%d] %s", t.buf, label)
          end,
        }, function(choice)
          if choice then
            for _, t in ipairs(terms) do
              if t ~= choice and t:win_valid() then t:hide() end
            end
            local claude_buf = require("claudecode.terminal").get_active_terminal_bufnr()
            if claude_buf then
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                if vim.api.nvim_win_get_buf(win) == claude_buf then
                  vim.api.nvim_win_close(win, false)
                end
              end
            end
            choice:show()
            choice:focus()
          end
        end)
      end, desc = "List terminals" },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "snacks_picker_list",
        callback = function(ev)
          local opts = { buffer = ev.buf, silent = true }
          vim.keymap.set("n", "<C-h>", function() vim.cmd("TmuxNavigateLeft") end, opts)
          vim.keymap.set("n", "<C-j>", function() vim.cmd("TmuxNavigateDown") end, opts)
          vim.keymap.set("n", "<C-k>", function() vim.cmd("TmuxNavigateUp") end, opts)
          vim.keymap.set("n", "<C-l>", function() vim.cmd("TmuxNavigateRight") end, opts)
        end,
      })
    end,
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
