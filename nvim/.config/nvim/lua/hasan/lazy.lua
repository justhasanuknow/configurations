-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "lazy.nvim kurulamadı:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

-- Read plugin definitions from lua/hasan/plugins

local extra_rtp = {}
if vim.fn.isdirectory("/usr/lib/nvim") == 1 then
  table.insert(extra_rtp, "/usr/lib/nvim")
end

require("lazy").setup({
  spec = {
    { import = "hasan.plugins" },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = false },
  performance = {
    rtp = {
      paths = extra_rtp,
    },
  },
})
