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
│           └── lua/hasan/
│               ├── options.lua       # vim.opt settings
│               ├── keymaps.lua       # key mappings
│               ├── lazy.lua          # lazy.nvim bootstrap + setup
│               └── plugins/          # one file per plugin
└── tmux/
    └── .tmux.conf
```

## Requirements

- **git**, **stow**
- **tmux** 3.x
- **Neovim** 0.10+ (developed against 0.11.6)
- **C compiler** (`gcc` / `build-essential`) — needed for treesitter parsers

```bash
sudo apt install git stow tmux neovim build-essential
```

## Installation

```bash
git clone https://github.com/justhasanuknow/configurations.git ~/configurations
cd ~/configurations
stow tmux nvim
```

Packages can be installed selectively: `stow nvim` links only the Neovim config.

To unlink:

```bash
stow -D nvim
```

### After installation

```bash
nvim
```

On first launch, lazy.nvim bootstraps itself and installs the versions pinned in `lazy-lock.json`.

If tmux is already running, reload its config:

```bash
tmux kill-server    # or, inside tmux: Ctrl-a r
```

### Conflict warning

If a real file already exists at the target path, stow aborts the whole operation.
Back it up and remove it first:

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

Plugin manager: [lazy.nvim](https://github.com/folke/lazy.nvim).
Plugin specs live under `lua/hasan/plugins/`, one file each.

### Key mappings

Leader: `<Space>`

| Key | Mode | Action |
|---|---|---|
| `<leader>w` | normal | Write |
| `<leader>q` | normal | Quit |
| `<leader>p` | visual | Paste over selection without clobbering the register |
| `<Esc>` | normal | Clear search highlight |
| `J` / `K` | visual | Move selected lines down/up |
| `<` / `>` | visual | Indent/dedent, keeping the selection |
| `<C-h/j/k/l>` | normal | Move between splits and tmux panes |

### Plugins

| Plugin | Why |
|---|---|
| `christoomey/vim-tmux-navigator` | One set of keys to move across Neovim splits and tmux panes |

## Notes

### Treesitter parser path on Debian/Ubuntu

The Debian/Ubuntu package ships Neovim's bundled treesitter parsers in `/usr/lib/nvim/parser/`,
but that path is not added to `runtimepath` automatically. On top of that, lazy.nvim resets
`runtimepath` for startup performance (`performance.rtp.reset` is on by default), so appending
the path in `options.lua` has no effect — it gets wiped once lazy.nvim loads.

The fix goes through lazy.nvim's own mechanism, in `lazy.lua`:

```lua
performance = { rtp = { paths = extra_rtp } }
```

It is guarded by an `isdirectory` check so it stays harmless on machines without that path.

**General rule:** anything appended to `runtimepath` before lazy.nvim loads is lost.

### Clipboard

`clipboard = "unnamedplus"` sends yanks straight to the system clipboard. This does not work
over SSH on a remote machine; OSC 52 support is planned for that case.

### Security

This repository is public. It contains no API keys, tokens, SSH config or private keys — and must not.

## Useful commands

```bash
# Sync plugins from the terminal
nvim --headless "+Lazy! sync" +qa

# Restore the versions pinned in the lockfile
nvim --headless "+Lazy! restore" +qa

# Is a file discoverable on runtimepath?
nvim --headless "+lua print(vim.inspect(vim.api.nvim_get_runtime_file('parser/lua.so', true)))" +qa; echo
```

From inside Neovim: `:Lazy` (panel), `:Lazy profile` (startup timings), `:checkhealth`.

## Roadmap

- [ ] nvim-treesitter
- [ ] Telescope (fuzzy finder)
- [ ] LSP + completion (mason, lspconfig, blink.cmp)
- [ ] Formatting / linting (conform.nvim, nvim-lint)
- [ ] Git integration (gitsigns, lazygit)
- [ ] Colorscheme and statusline
- [ ] Language-specific setup: Python, Zig, LaTeX (vimtex), Svelte/TypeScript
- [ ] tmux status bar, TPM, sessionizer
- [ ] `install.sh` — one-command setup that installs dependencies and runs stow
- [ ] Shell config (zsh), git config, terminal emulator config
