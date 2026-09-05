-- File explorer: Telescope finds files by name; this is for browsing an unfamiliar
-- tree and for creating, renaming and moving files in place
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File explorer" },
    { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal current file in explorer" },
  },
  opts = {
    close_if_last_window = true,
    filesystem = {
      -- Keep the tree pointed at the buffer being edited
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      filtered_items = {
        -- Dotfiles are the point of this repo; build output is not
        hide_dotfiles = false,
        hide_gitignored = true,
      },
    },
    window = { width = 32 },
  },
}
