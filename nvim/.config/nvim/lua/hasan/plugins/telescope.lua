-- Fuzzy finder: files, live grep, buffers, git and more through one interface
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Native C sorter, much faster on large projects
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Grep in project" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Open buffers" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
    { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
    { "<leader>f/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Search in current buffer" },
  },
  config = function()
    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        -- Ignore noise that is never worth searching
        file_ignore_patterns = { "%.git/", "node_modules/", "%.lock" },
        path_display = { "truncate" },
      },
      pickers = {
        find_files = {
          -- Include dotfiles; this config lives in hidden directories
          hidden = true,
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
