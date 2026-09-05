-- LSP: mason installs the servers, nvim-lspconfig provides their configs,
-- Neovim itself activates them through vim.lsp.enable
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    ensure_installed = {
      "lua_ls", -- Lua (this config itself)
      "basedpyright", -- Python types
      "ruff", -- Python linting and formatting
      "clangd", -- C and C++
      "ts_ls", -- JavaScript and TypeScript
      "svelte",
      "html",
      "cssls",
      "jsonls",
      "bashls",
      "texlab", -- LaTeX
    },
  },
  config = function(_, opts)
    require("mason-lspconfig").setup(opts)

    -- Server specific settings, merged into the configs shipped by nvim-lspconfig
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          -- Stop it from warning about the global `vim` table
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    vim.diagnostic.config({
      virtual_text = true,
      severity_sort = true,
      float = { border = "rounded" },
    })

    -- Extra mappings and per-buffer setup, applied when a server attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = args.buf, desc = desc })
        end

        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gD", vim.lsp.buf.declaration, "Go to declaration")
        -- <leader>e belongs to the file explorer; diagnostics live under the lsp prefix
        map("<leader>ld", vim.diagnostic.open_float, "Show diagnostic")

        -- Inlay hints: inline type and parameter name annotations
        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })

        map("<leader>lh", function()
          local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf })
          vim.lsp.inlay_hint.enable(not enabled, { bufnr = args.buf })
        end, "Toggle inlay hints")

        map("<leader>d", function()
          vim.diagnostic.enable(not vim.diagnostic.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
        end, "Toggle diagnostics")
      end,
    })
  end,
}
