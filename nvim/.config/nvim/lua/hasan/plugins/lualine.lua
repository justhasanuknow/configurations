-- Status line: mode, git branch, diagnostics and position
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = "auto",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_c = { { "filename", path = 1 } },
    },
  },
}
