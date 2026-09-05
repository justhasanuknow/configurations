-- Colorschemes: loaded first so other plugins pick up their highlight groups.
-- alduin is the active one; the rest are kept around to try with
-- :Telescope colorscheme
return {
  {
    -- Vimscript colorscheme, no setup() to call
    "alessandroyorba/alduin",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("alduin")
    end,
  },

  -- Alternatives, not active by default. Loaded after startup so they cost
  -- nothing at launch but still show up in :Telescope colorscheme
  {
    "rose-pine/neovim",
    name = "rose-pine",
    event = "VeryLazy",
    opts = {
      variant = "main", -- main, moon or dawn
    },
  },
  { "folke/tokyonight.nvim", event = "VeryLazy" },
  { "catppuccin/nvim", name = "catppuccin", event = "VeryLazy" },
  { "ellisonleao/gruvbox.nvim", event = "VeryLazy" },
  { "rebelot/kanagawa.nvim", event = "VeryLazy" },
  { "EdenEast/nightfox.nvim", event = "VeryLazy" },
  { "scottmckendry/cyberdream.nvim", event = "VeryLazy" },
  { "sainnhe/everforest", event = "VeryLazy" },
  { "bluz71/vim-moonfly-colors", name = "moonfly", event = "VeryLazy" },
}
