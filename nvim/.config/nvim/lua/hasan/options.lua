vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.wrap = false

vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300

-- Clipboard. Locally the system clipboard is reached through wl-copy, xclip or
-- win32yank, whichever Neovim finds. Over SSH none of those exist on the remote
-- side, so yanks travel to the local machine's clipboard through the terminal
-- (OSC 52; tmux passes it on with set-clipboard on). Reading the clipboard back
-- that way needs terminal permission and stalls inside tmux, so paste returns
-- the last thing copied instead; text from the local machine still arrives
-- through the terminal's own paste.
vim.opt.clipboard = "unnamedplus"

if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")
  local last = { {}, "v" }

  local function copy(reg)
    local send = osc52.copy(reg)
    return function(lines, regtype)
      last = { lines, regtype }
      send(lines, regtype)
    end
  end

  local function paste()
    return last
  end

  vim.g.clipboard = {
    name = "OSC 52",
    copy = { ["+"] = copy("+"), ["*"] = copy("*") },
    paste = { ["+"] = paste, ["*"] = paste },
  }
end
