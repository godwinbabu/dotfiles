return {
  {
    "williamboman/mason.nvim",
    opts = {
      ui = { border = "rounded" },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "gopls",
        "jsonls",
        "html",
        "cssls",
        "bashls",
        "yamlls",
      },
      automatic_installation = true,
    },
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "j-hui/fidget.nvim", opts = {} },
      -- { "folke/lazydev.nvim", ft = "lua", opts = {} }, -- Replaces neodev
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = desc })
          end

          map("gd", "<cmd>Telescope lsp_definitions<CR>", "Go to definition")
          map("gD", vim.lsp.buf.declaration, "Go to declaration")
          map("gr", "<cmd>Telescope lsp_references<CR>", "Go to references")
          map("gi", "<cmd>Telescope lsp_implementations<CR>", "Go to implementation")
          map("gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to type definition")
          map("K", vim.lsp.buf.hover, "Hover documentation")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format buffer")
          map("<leader>cs", vim.lsp.buf.signature_help, "Signature help")
        end,
      })

      -- Configure servers using new vim.lsp.config API (Neovim 0.11+)
      vim.lsp.config("*", {
        capabilities = capabilities,
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            completion = { callSnippet = "Replace" },
          },
        },
      })

      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      vim.lsp.config("gopls", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("yamlls", { capabilities = capabilities })

      -- Enable configured servers
      vim.lsp.enable({
        "lua_ls",
        "ts_ls",
        "pyright",
        "rust_analyzer",
        "gopls",
        "jsonls",
        "html",
        "cssls",
        "bashls",
        "yamlls",
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = "rounded", source = true },
      })
      -- Diagnostics config
      --      vim.diagnostic.config({
      --        virtual_text = { prefix = "●" },
      --        signs = true,
      --        underline = true,
      --        update_in_insert = false,
      --        severity_sort = true,
      --        float = { border = "rounded", source = true },
      --      })
      --
      --      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      --      for type, icon in pairs(signs) do
      --        local hl = "DiagnosticSign" .. type
      --        vim.fn.sign_define(hl, { text = icon, texthl = hl })
      --      end
    end,
  },

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true }) end, desc = "Format buffer" },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
        rust = { "rustfmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "eslint_d" },
        typescript = { "eslint_d" },
        -- python = { "ruff" },  -- Uncomment after: pip install ruff
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("lint", { clear = true }),
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
  },
}
