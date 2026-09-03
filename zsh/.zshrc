# --- PATH --------------------------------------------------------------------
# Own binaries first, so tmux-sessionizer and friends always resolve
export PATH="$HOME/.local/bin:$PATH"

# --- History -----------------------------------------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

setopt SHARE_HISTORY          # all open shells see each other's history
setopt HIST_IGNORE_ALL_DUPS   # never store a command twice
setopt HIST_IGNORE_SPACE      # commands starting with a space are not saved
setopt HIST_REDUCE_BLANKS     # trim superfluous whitespace

# --- Completion --------------------------------------------------------------
autoload -Uz compinit && compinit

# Case-insensitive matching, and match anywhere in the word
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'l:|=* r:|=*'
zstyle ':completion:*' menu select

# --- Aliases -----------------------------------------------------------------
alias ll='ls -lah --color=auto'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias v='nvim'
alias lg='lazygit'

# --- fzf ---------------------------------------------------------------------
# Ctrl-r history search, Ctrl-t file picker, Alt-c directory jump
if command -v fzf >/dev/null; then
    source <(fzf --zsh)
fi

# Use fd for file listing: faster and respects .gitignore
export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'

# --- Plugins -----------------------------------------------------------------
# Minimal plugin loader: clone on first use, then source. No framework.
ZSH_PLUGIN_DIR="$HOME/.local/share/zsh/plugins"

zsh_plugin() {
    local repo="$1"
    local name="${repo##*/}"
    local dir="$ZSH_PLUGIN_DIR/$name"

    if [[ ! -d "$dir" ]]; then
        git clone --depth 1 "https://github.com/$repo" "$dir"
    fi

    source "$dir/$name.zsh" 2>/dev/null \
        || source "$dir/$name.plugin.zsh"
}

zsh_plugin zsh-users/zsh-autosuggestions
# Must be loaded last; it hooks into everything that came before
zsh_plugin zsh-users/zsh-syntax-highlighting

# --- Prompt ------------------------------------------------------------------
if command -v starship >/dev/null; then
    eval "$(starship init zsh)"
fi

