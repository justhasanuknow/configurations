-- Formatting: explicit, never on save
return {
  "stevearc/conform.nvim",
  dependencies = {
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      dependencies = { "mason-org/mason.nvim" },
      opts = {
        ensure_installed = {
          "stylua", -- Lua
          "prettier", -- JS, TS, Svelte, HTML, CSS, JSON, YAML, Markdown
          "clang-format", -- C and C++
        },
      },
    },
  },
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Format buffer or selection",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      -- ruff is already installed as an LSP server; its formatter is the same binary
      python = { "ruff_format" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      svelte = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },
    -- No format_on_save: formatting is always triggered explicitly
  },
}
