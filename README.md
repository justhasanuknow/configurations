# configurations

Personal dotfiles for a terminal-centric development environment: tmux + Neovim, managed with GNU stow.

The goal is to bring up an identical environment on any machine — workstation, laptop, VPS,
Raspberry Pi — with a `git clone` and a single `stow` command.

## Contents

| Package | Contains | Target |
|---|---|---|
| `tmux/` | `.tmux.conf` | `~/.tmux.conf` |
| `nvim/` | Neovim config (Lua) | `~/.config/nvim` |

Each package directory mirrors `$HOME` internally; stow reflects that structure into `$HOME` as symlinks.

```
configurations/
├── nvim/
│   └── .config/
│       └── nvim/
│           ├── init.lua              # entry point: leader + requires
│           ├── lazy-lock.json        # plugin version lockfile
│           ├── ftplugin/             # per-filetype overrides
│           └── lua/hasan/
│               ├── options.lua       # vim.opt settings
│               ├── keymaps.lua       # key mappings
│               ├── lazy.lua          # lazy.nvim bootstrap + setup
│               └── plugins/          # one file per plugin
└── tmux/
    └── .tmux.conf
```

## Requirements

- **git**, **stow**, **curl**, **unzip**
- **tmux** 3.x
- **Neovim** 0.12+ — required by the treesitter setup
- **tree-sitter CLI** 0.26.1 or later
- **C compiler** (`gcc` / `build-essential`) — for treesitter parsers
- **Node.js** and **npm** — several language servers are npm packages
- **python3-venv** — for pip-based language servers
- **ripgrep** and **fd** — Telescope search backends
- **lazygit** — git UI
- A **Nerd Font** in your terminal — for icons

### On Ubuntu

The archive ships Neovim 0.11 and an outdated tree-sitter CLI, so both are installed from
upstream releases:

```bash
# Packages available from the archive
sudo apt install git stow tmux build-essential curl unzip \
                 nodejs npm python3-venv ripgrep fd-find lazygit

# fd is installed as fdfind on Debian/Ubuntu
mkdir -p ~/.local/bin && ln -sf "$(which fdfind)" ~/.local/bin/fd

# Neovim
cd /tmp
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# tree-sitter CLI
cd /tmp
curl -LO https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-cli-linux-x64.zip
unzip -o tree-sitter-cli-linux-x64.zip
sudo install -m 755 tree-sitter /usr/local/bin/tree-sitter
```

Make sure `~/.local/bin` is on your `PATH`.

## Installation

```bash
git clone https://github.com/justhasanuknow/configurations.git ~/configurations
cd ~/configurations
stow tmux nvim
```

Packages can be installed selectively: `stow nvim` links only the Neovim config.
To unlink: `stow -D nvim`.

### After installation

```bash
nvim
```

On first launch, lazy.nvim bootstraps itself and installs the versions pinned in
`lazy-lock.json`. Treesitter parsers and Mason's language servers are then downloaded in the
background — watch progress with `:Lazy`, `:TSStatus` and `:Mason`.

If tmux is already running, reload its config with `tmux kill-server` or `Ctrl-a r`.

### Conflict warning

If a real file already exists at a target path, stow aborts the whole operation. Back it up
and remove it first:

```bash
mv ~/.tmux.conf ~/.tmux.conf.bak
```

`stow --adopt` can pull an existing file into the repo instead, but it overwrites the repo's
version — use with care.

## tmux

| Setting | Value |
|---|---|
| Prefix | `Ctrl-a` |
| Config reload | `Ctrl-a r` |
| Mouse | enabled |
| Window/pane index | starts at 1, windows renumbered automatically |
| `escape-time` | 10 ms — avoids the Esc delay in Neovim |
| Terminal | `tmux-256color` + RGB override (true color) |

`Ctrl-h/j/k/l` moves seamlessly between Neovim splits and tmux panes (the tmux half of
vim-tmux-navigator: if Neovim is running in the active pane, the key is forwarded to it).

## Neovim

Written from scratch — no distribution (LazyVim, NvChad, etc.). Guiding principle:
**don't install a plugin for a pain you haven't felt.** Every plugin file opens with a
one-line comment explaining why it's there.

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim). Plugin specs live under
`lua/hasan/plugins/`, one file each.

### Plugins

| Plugin | Why |
|---|---|
| `christoomey/vim-tmux-navigator` | One set of keys across Neovim splits and tmux panes |
| `neovim-treesitter/nvim-treesitter` | Parser and query management, syntax-aware highlighting and indentation |
| `nvim-treesitter/nvim-treesitter-textobjects` | Select, move and swap by function, class or parameter |
| `nvim-telescope/telescope.nvim` | Fuzzy finder for files, text, buffers and more |
| `mason-org/mason.nvim` + `mason-lspconfig` + `nvim-lspconfig` | Language server installation and configuration |
| `saghen/blink.cmp` | Completion from LSP, snippets, paths and buffer words |
| `stevearc/conform.nvim` | Formatting, triggered explicitly |
| `lewis6991/gitsigns.nvim` | Hunk signs, staging and blame |
| `kdheepak/lazygit.nvim` | Full git UI in a floating window |
| `rose-pine/neovim` | Active colorscheme (several alternatives are installed too) |
| `nvim-lualine/lualine.nvim` | Status line |
| `folke/which-key.nvim` | Shows available keybindings after a prefix key |

### Language servers

Installed automatically through Mason: `lua_ls`, `basedpyright`, `ruff`, `clangd`, `ts_ls`,
`svelte`, `html`, `cssls`, `jsonls`, `bashls`, `texlab`.

Formatters: `stylua`, `prettier`, `clang-format`, plus `ruff format` for Python.

### Key mappings

Leader: `<Space>`

**Basics**

| Key | Mode | Action |
|---|---|---|
| `<leader>w` / `<leader>q` | normal | Write / quit |
| `<Esc>` | normal | Clear search highlight |
| `<leader>p` | visual | Paste over selection without clobbering the register |
| `J` / `K` | visual | Move selected lines down/up |
| `<` / `>` | visual | Indent/dedent, keeping the selection |
| `<C-h/j/k/l>` | normal | Move between splits and tmux panes |

**Find (Telescope)**

| Key | Action |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across the project |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fd` | Diagnostics |
| `<leader>f/` | Search in the current buffer |

**Text objects**

| Key | Action |
|---|---|
| `af` / `if` | Function, outer / inner |
| `ac` / `ic` | Class, outer / inner |
| `aa` / `ia` | Parameter, outer / inner |
| `]f` / `[f` | Jump to next / previous function |
| `<leader>sa` / `<leader>sA` | Swap parameter with next / previous |

**LSP** — on top of Neovim's built-in `K`, `grn`, `gra`, `grr`, `gri`, `gO`, `]d`, `[d`

| Key | Action |
|---|---|
| `gd` / `gD` | Go to definition / declaration |
| `<leader>e` | Show diagnostic under the cursor |
| `<leader>h` | Toggle inlay hints |
| `<leader>cf` | Format buffer (normal) or selection (visual) |

**Completion** (insert mode)

| Key | Action |
|---|---|
| `<C-space>` | Open the menu |
| `<C-n>` / `<C-p>` | Next / previous item |
| `<C-y>` | Accept |
| `<C-e>` | Dismiss |

**Git**

| Key | Action |
|---|---|
| `<leader>gg` | Open lazygit |
| `]h` / `[h` | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | Stage / reset hunk (visual: selected lines) |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gd` | Diff against index |

### Colorschemes

`rose-pine` is active. Also installed and switchable with `:Telescope colorscheme`:
tokyonight, catppuccin, gruvbox, kanagawa, nightfox, cyberdream, everforest, moonfly.

## Notes

### lazy.nvim resets runtimepath

Anything appended to `runtimepath` before lazy.nvim loads is lost — it resets the path for
startup performance. If a path must be added, go through `performance.rtp.paths` in
`lazy.lua`.

### nvim-treesitter was archived

The original `nvim-treesitter/nvim-treesitter` was archived in April 2026. This config uses
the community fork at `neovim-treesitter/nvim-treesitter`, which discovers parsers and
queries from a community registry.

Watch out: the fork's own README shows the *old* (archived) repository path in its
lazy.nvim installation snippet.

Textobject queries do not come from the fork — `nvim-treesitter-textobjects` ships its own.

### LSP setup is three separate jobs

Mason installs the server binary, nvim-lspconfig supplies its configuration, and Neovim
activates it through `vim.lsp.enable`. The older `require("lspconfig").<server>.setup{}`
API is no longer used.

### Formatting is manual

There is no format-on-save. Formatting is always triggered with `<leader>cf`, so shared
projects with different formatter settings don't produce noisy diffs.

### Clipboard

`clipboard = "unnamedplus"` sends yanks straight to the system clipboard. This does not work
over SSH on a remote machine; OSC 52 support is planned for that case.

### Security

This repository is public. It contains no API keys, tokens, SSH config or private keys — and
must not.

## Useful commands

```bash
nvim --headless "+Lazy! sync" +qa       # sync plugins from the terminal
nvim --headless "+Lazy! restore" +qa    # restore the versions in the lockfile
```

From inside Neovim: `:Lazy` (plugins), `:Mason` (servers and tools), `:TSStatus` (parsers),
`:checkhealth` (general), `:checkhealth vim.lsp` (attached servers), `:ConformInfo`
(formatters for the current buffer).

## Roadmap

- [ ] File explorer — decide between oil.nvim, neo-tree and telescope-file-browser
- [ ] LaTeX: TeX Live and vimtex
- [ ] `install.sh` — one-command setup that installs dependencies and runs stow
- [ ] tmux status bar, TPM, sessionizer
- [ ] Hyprland config
- [ ] Shell config (zsh), git config, terminal emulator config
- [ ] OSC 52 clipboard for remote sessions
