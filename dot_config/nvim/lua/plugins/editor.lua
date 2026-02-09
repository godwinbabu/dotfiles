return {
  -- File explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
      { "<leader>o", "<cmd>Neotree focus<CR>",  desc = "Focus file explorer" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        filesystem = {
          follow_current_file = { enabled = true },
          use_libuv_file_watcher = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
        window = {
          width = 35,
          mappings = {
            ["<space>"] = "none",
            ["l"] = "open",
            ["h"] = "close_node",
            ["<cr>"] = "open",
            ["v"] = "open_vsplit",
            ["s"] = "open_split",
          },
        },
        default_component_configs = {
          git_status = {
            symbols = {
              added = "",
              modified = "",
              deleted = "✖",
              renamed = "󰁕",
              untracked = "",
              ignored = "",
              unstaged = "󰄱",
              staged = "",
              conflict = "",
            },
          },
        },
      })
    end,
  },

  -- Telescope (fuzzy finder)
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<CR>",                desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<CR>",                 desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<CR>",                   desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<CR>",                 desc = "Help tags" },
      { "<leader>fr", "<cmd>Telescope oldfiles<CR>",                  desc = "Recent files" },
      { "<leader>fc", "<cmd>Telescope commands<CR>",                  desc = "Commands" },
      { "<leader>fk", "<cmd>Telescope keymaps<CR>",                   desc = "Keymaps" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>",      desc = "Document symbols" },
      { "<leader>fw", "<cmd>Telescope grep_string<CR>",               desc = "Find word under cursor" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in buffer" },
      { "<C-p>",      "<cmd>Telescope find_files<CR>",                desc = "Find files" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")

      telescope.setup({
        defaults = {
          prompt_prefix = "   ",
          selection_caret = " ",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { preview_width = 0.55 },
            width = 0.87,
            height = 0.80,
          },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
              ["<Esc>"] = actions.close,
            },
          },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        },
        pickers = {
          find_files = { hidden = true },
        },
      })

      telescope.load_extension("fzf")
    end,
  },

  -- Treesitter - Neovim 0.11+ (highlighting is built-in)
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Neovim 0.11+ has built-in treesitter highlighting
      -- This plugin just provides :TSInstall and :TSUpdate
    end,
  },

  -- Treesitter textobjects (separate plugin for Neovim 0.11+)
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      -- Selection textobjects
      vim.keymap.set({ "x", "o" }, "af", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
      end, { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
      end, { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inner class" })
      vim.keymap.set({ "x", "o" }, "aa", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select outer argument" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        require("nvim-treesitter-textobjects.select").select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select inner argument" })

      -- Movement
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end, { desc = "Next function" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end, { desc = "Prev function" })
      vim.keymap.set({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer", "textobjects") end, { desc = "Next class" })
      vim.keymap.set({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer", "textobjects") end, { desc = "Prev class" })
      vim.keymap.set({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner", "textobjects") end, { desc = "Next argument" })
      vim.keymap.set({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner", "textobjects") end, { desc = "Prev argument" })

      -- Swap
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>sn", function() swap.swap_next("@parameter.inner") end, { desc = "Swap next argument" })
      vim.keymap.set("n", "<leader>sp", function() swap.swap_previous("@parameter.inner") end, { desc = "Swap prev argument" })
    end,
  },

  -- Auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,
      })
    end,
  },

  -- Surround
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Comment
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  -- Todo comments
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "<leader>xt", "<cmd>TodoTelescope<CR>", desc = "Todo comments" },
    },
  },

  -- Better diagnostics
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>",              desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics" },
      { "<leader>xl", "<cmd>Trouble loclist toggle<CR>",                  desc = "Location list" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<CR>",                   desc = "Quickfix list" },
    },
    opts = {},
  },

  -- Search and replace
  {
    "nvim-pack/nvim-spectre",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Search and replace" },
    },
  },

  -- Flash (better navigation)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", function() require("flash").jump() end,       mode = { "n", "x", "o" }, desc = "Flash" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash Treesitter" },
    },
  },

  -- Seamless navigation between tmux panes and vim splits
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<CR>",  desc = "Navigate left (tmux/vim)" },
      { "<C-j>", "<cmd>TmuxNavigateDown<CR>",  desc = "Navigate down (tmux/vim)" },
      { "<C-k>", "<cmd>TmuxNavigateUp<CR>",    desc = "Navigate up (tmux/vim)" },
      { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Navigate right (tmux/vim)" },
    },
  },
}
