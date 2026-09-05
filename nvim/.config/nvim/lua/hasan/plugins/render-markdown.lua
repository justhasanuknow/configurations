-- Markdown rendered in place: headings, lists, tables and code blocks are styled
-- in the buffer itself; the line being edited shows the raw text again
return {
  "MeanderingProgrammer/render-markdown.nvim",
  dependencies = { "neovim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
  ft = "markdown",
  keys = {
    { "<leader>cm", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown rendering" },
  },
  opts = {},
}
