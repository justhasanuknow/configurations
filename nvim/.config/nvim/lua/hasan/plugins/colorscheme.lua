-- Colorschemes: loaded first so other plugins pick up their highlight groups.
-- rose-pine is the active one; the rest are kept around to try with
-- :Telescope colorscheme
return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "main", -- main, moon or dawn
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
      vim.cmd.colorscheme("rose-pine")
    end,
  },

  -- Alternatives, not active by default
  { "folke/tokyonight.nvim", lazy = false, priority = 900 },
  { "catppuccin/nvim", name = "catppuccin", lazy = false, priority = 900 },
  { "ellisonleao/gruvbox.nvim", lazy = false, priority = 900 },
  { "rebelot/kanagawa.nvim", lazy = false, priority = 900 },
  { "EdenEast/nightfox.nvim", lazy = false, priority = 900 },
  { "scottmckendry/cyberdream.nvim", lazy = false, priority = 900 },
  { "sainnhe/everforest", lazy = false, priority = 900 },
  { "bluz71/vim-moonfly-colors", name = "moonfly", lazy = false, priority = 900 },
}
