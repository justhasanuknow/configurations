-- Popup that shows available keybindings after a prefix key
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    delay = 300,
    -- Name the leader prefixes so the popup reads "find" instead of "+prefix"
    spec = {
      { "<leader>f", group = "find" },
      { "<leader>g", group = "git" },
      { "<leader>c", group = "code" },
      { "<leader>l", group = "lsp" },
      { "<leader>s", group = "swap" },
    },
  },
}
