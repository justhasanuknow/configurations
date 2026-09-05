# Key bindings

Every binding defined by this repository, grouped by program. Defaults that are not
overridden are listed only where they matter day to day.

## Shell (zsh)

| Key | Action |
|---|---|
| `Ctrl-r` | Fuzzy search command history |
| `Ctrl-t` | Fuzzy pick a file into the command line |
| `Alt-c` | Fuzzy `cd` into a subdirectory |
| `→` | Accept the grey autosuggestion |
| `Ctrl-←` / `Ctrl-→` | Move by word (stops at `/` and `-`) |
| `Home` / `End` / `Delete` | As labelled (bound explicitly for terminals that send `^[[H`, `^[[F`, `^[[3~`) |

Aliases: `v` → nvim, `lg` → lazygit, `ll` → `ls -lah`.

## tmux

Prefix: `Ctrl-a`

| Key | Action |
|---|---|
| `Ctrl-a r` | Reload config |
| `Ctrl-a f` | Project switcher: fuzzy-pick a directory under `~/programming` (or the dotfiles repo), switch to or create its session |
| `Ctrl-a Ctrl-s` / `Ctrl-a Ctrl-r` | Save / restore layout (continuum also saves every 15 min and restores on start) |
| `Ctrl-a I` / `Ctrl-a U` | Install / update plugins |
| `Ctrl-h/j/k/l` | Move between panes and Neovim splits, no prefix |
| `Ctrl-a [` | Enter copy mode (vi keys) |
| `v` / `y` (copy mode) | Start selection / copy to the system clipboard and leave |

## Neovim

Leader: `<Space>`. which-key names the prefixes: `<leader>f` find, `g` git, `c` code, `l` lsp,
`s` swap.

### Editing

| Key | Mode | Action |
|---|---|---|
| `<leader>w` / `<leader>q` | n | Write / quit |
| `<Esc>` | n | Clear search highlight |
| `<leader>p` | v | Paste over selection without clobbering the register |
| `J` / `K` | v | Move selected lines down / up |
| `<` / `>` | v | Indent / dedent, keeping the selection |
| `<C-h/j/k/l>` | n | Move between splits and tmux panes |

### Files and search

| Key | Mode | Action |
|---|---|---|
| `<leader>e` / `<leader>E` | n | Toggle the file explorer / reveal the current file in it |
| `<leader>ff` | n | Find files (dotfiles included) |
| `<leader>fg` | n | Grep in project |
| `<leader>fb` | n | Open buffers |
| `<leader>fr` | n | Recent files |
| `<leader>fh` | n | Help tags |
| `<leader>fk` | n | Keymaps |
| `<leader>fd` | n | Diagnostics |
| `<leader>f/` | n | Fuzzy search in the current buffer |

Inside the explorer (neo-tree defaults): `a` add, `d` delete, `r` rename, `y` / `x` / `p` copy /
cut / paste, `H` toggle hidden files, `R` refresh, `?` all mappings.

### Code

| Key | Mode | Action |
|---|---|---|
| `af` / `if`, `ac` / `ic`, `aa` / `ia` | o, x | Text objects: function, class, parameter |
| `]f` / `[f` | n, x, o | Next / previous function |
| `<leader>sa` / `<leader>sA` | n | Swap parameter with next / previous |
| `gd` / `gD` | n | Go to definition / declaration |
| `<leader>ld` | n | Diagnostic under the cursor |
| `<leader>d` | n | Toggle diagnostics for the buffer |
| `<leader>lh` | n | Toggle inlay hints |
| `<leader>cf` | n, v | Format buffer / selection |
| `<leader>cm` | n | Toggle markdown rendering (on by default for `.md` buffers) |

Neovim's built-in LSP mappings are used as-is: `K` hover, `grn` rename, `gra` code action,
`grr` references, `gri` implementation, `gO` document symbols, `]d` / `[d` next / previous
diagnostic.

### LaTeX (vimtex, `.tex` buffers only)

Local leader is also `<Space>`, so these sit next to the lsp mappings while editing LaTeX.

| Key | Mode | Action |
|---|---|---|
| `<leader>ll` | n | Start / stop continuous compilation (latexmk) |
| `<leader>lk` | n | Stop compilation |
| `<leader>lv` | n | Open the PDF at the cursor (zathura on the desktop) |
| `<leader>le` | n | Show compile errors |
| `<leader>lt` | n | Table of contents |
| `<leader>lc` | n | Clean auxiliary files |
| `<leader>li` | n | Compiler and project info |
| `dse` / `cse` / `tse` | n | Delete / change / toggle surrounding environment |
| `dsc` / `csc` | n | Delete / change surrounding command |
| `]]` / `[[` | n | Next / previous section |

### Git

| Key | Mode | Action |
|---|---|---|
| `<leader>gg` | n | lazygit |
| `]h` / `[h` | n | Next / previous hunk |
| `<leader>gs` / `<leader>gr` | n, v | Stage / reset hunk (selected lines in visual mode) |
| `<leader>gp` | n | Preview hunk |
| `<leader>gb` | n | Blame line |
| `<leader>gd` | n | Diff against index |

### Completion

| Key | Mode | Action |
|---|---|---|
| `<C-space>` | i | Open the menu, or toggle documentation |
| `<C-n>` / `<C-p>` | i | Next / previous item |
| `<C-y>` | i | Accept |
| `<C-e>` | i | Dismiss |

## Hyprland

Mod key: `Super`

| Key | Action |
|---|---|
| `Super+Return` | Terminal (kitty) |
| `Super+D` | Launcher (wofi) |
| `Super+Q` | Close window |
| `Super+H/J/K/L` | Focus left / down / up / right |
| `Super+Shift+H/J/K/L` | Move window |
| `Super+1..5` / `Super+Shift+1..5` | Go to / move window to workspace |
| `Super+Tab` | Previous workspace |
| `Super+F` / `V` / `P` / `S` | Fullscreen / float / pseudo-tile / toggle split |
| `Super+B` / `Super+Shift+B` | Toggle / restart waybar |
| `Super+Shift+E` | Exit Hyprland |
| `Super+Escape` | Lock screen (`Super+Shift+L` is taken by "move window right") |
| Lid close | Lock screen |
| `Super+Shift+S` / `Super+Print` | Screenshot: region / full screen — clipboard, file and notification |
| `Super+Shift+V` | Clipboard history picker (cliphist in wofi) |
| `XF86Audio*`, `XF86MonBrightness*` | Volume, mic mute, brightness, play / next / prev (also while locked) |
| `Super` + drag | Move (left) / resize (right) window |
