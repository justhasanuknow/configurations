-- Completion engine: merges LSP, snippets, buffer words and paths into one menu
return {
  "saghen/blink.cmp",
  -- Tagged release: downloads a prebuilt fuzzy matcher instead of building with Rust
  version = "1.*",
  dependencies = { "rafamadriz/friendly-snippets" },
  event = "InsertEnter",
  opts = {
    keymap = { preset = "default" },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
