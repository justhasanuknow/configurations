#!/usr/bin/env bash
# Sets up this machine: installs dependencies, backs up conflicting files
# and links the config packages with GNU stow.
#
# Supports Debian/Ubuntu (apt) and Arch (pacman).
#
# Usage:
#   ./install.sh            terminal environment only
#   ./install.sh --desktop  also install and link the Hyprland desktop (Arch only)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(tmux nvim scripts zsh starship git)
DESKTOP_PACKAGES=(hypr kitty waybar)
INSTALL_DESKTOP=0
STAMP="$(date +%Y%m%d%H%M%S)"

# Minimum versions required by the Neovim config
NVIM_MIN="0.12.0"
TREE_SITTER_MIN="0.26.1"

info() { printf '\n==> %s\n' "$1"; }
warn() { printf '\n!!  %s\n' "$1" >&2; }

# Returns 0 if $1 is greater than or equal to $2
version_at_least() {
    [ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" = "$2" ]
}

# --- Distro detection --------------------------------------------------------

detect_distro() {
    if [ ! -f /etc/os-release ]; then
        echo "unknown"
        return
    fi

    # shellcheck disable=SC1091
    . /etc/os-release

    case "${ID:-}" in
        debian | ubuntu) echo "debian" ;;
        arch | endeavouros | cachyos | manjaro) echo "arch" ;;
        *)
            # Derivatives usually declare their base here
            case "${ID_LIKE:-}" in
                *debian* | *ubuntu*) echo "debian" ;;
                *arch*) echo "arch" ;;
                *) echo "unknown" ;;
            esac
            ;;
    esac
}

DISTRO="$(detect_distro)"

# --- Dependencies ------------------------------------------------------------

install_packages_debian() {
    info "Installing packages with apt"
    sudo apt update
    sudo apt install -y \
        git stow tmux build-essential curl unzip \
        nodejs npm python3-venv ripgrep fd-find lazygit fzf zsh

    # fd ships as fdfind on Debian and Ubuntu
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"

    # Ubuntu LTS lags behind on neovim and tree-sitter; handled separately below
}

install_packages_arch() {
    info "Installing packages with pacman"
    sudo pacman -S --needed --noconfirm \
        git stow tmux base-devel curl unzip \
        nodejs npm ripgrep fd lazygit fzf zsh starship \
        neovim tree-sitter-cli
}

install_packages() {
    case "$DISTRO" in
        debian) install_packages_debian ;;
        arch) install_packages_arch ;;
        *)
            warn "Unknown distribution, skipping package installation."
            warn "Install these yourself: git stow tmux curl unzip a C compiler"
            warn "nodejs npm ripgrep fd lazygit fzf zsh starship neovim tree-sitter-cli"
            ;;
    esac
}

# --- Tools that distro packages may be too old for ---------------------------

ensure_neovim() {
    if command -v nvim >/dev/null; then
        local version
        version="$(nvim --version | head -1 | sed 's/^NVIM v//')"
        if version_at_least "$version" "$NVIM_MIN"; then
            info "Neovim $version is recent enough"
            return
        fi
        info "Neovim $version is older than $NVIM_MIN, installing from upstream"
    else
        info "Installing Neovim from upstream"
    fi

    local url="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz"
    curl -Lo /tmp/nvim.tar.gz "$url"
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf /tmp/nvim.tar.gz
    sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
    hash -r
}

ensure_tree_sitter() {
    if command -v tree-sitter >/dev/null; then
        local version
        version="$(tree-sitter --version | awk '{print $2}')"
        if version_at_least "$version" "$TREE_SITTER_MIN"; then
            info "tree-sitter $version is recent enough"
            return
        fi
        info "tree-sitter $version is older than $TREE_SITTER_MIN, installing from upstream"
    else
        info "Installing tree-sitter CLI from upstream"
    fi

    local url="https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-cli-linux-x64.zip"
    curl -Lo /tmp/tree-sitter.zip "$url"
    unzip -o /tmp/tree-sitter.zip -d /tmp
    sudo install -m 755 /tmp/tree-sitter /usr/local/bin/tree-sitter
    hash -r
}

# --- Desktop (Hyprland) ------------------------------------------------------

install_desktop() {
    [ "$INSTALL_DESKTOP" -eq 1 ] || return 0

    if [ "$DISTRO" != "arch" ]; then
        warn "Desktop setup is only supported on Arch-based systems, skipping."
        return 0
    fi

    info "Installing Hyprland desktop packages"
    sudo pacman -S --needed --noconfirm \
        hyprland xdg-desktop-portal-hyprland \
        kitty wofi waybar hyprpaper \
        ttf-jetbrains-mono-nerd

    # Machine-specific Hyprland settings are never committed; seed from the template
    local machine="$REPO_DIR/hypr/.config/hypr/machine.lua"
    if [ ! -f "$machine" ]; then
        cp "$machine.example" "$machine"
        info "Created hypr/machine.lua from template; adjust monitors for this machine"
    fi
}

# --- Git identity ------------------------------------------------------------

setup_git_identity() {
    local target="$HOME/.gitconfig.local"

    if [ -f "$target" ]; then
        info "git identity: $target already exists, skipping"
        return
    fi

    local current_name current_email
    current_name="$(git config --global user.name || true)"
    current_email="$(git config --global user.email || true)"

    if [ -n "$current_name" ] && [ -n "$current_email" ]; then
        info "git identity already set: $current_name <$current_email>"
        read -rp "    Move it into $target? [Y/n] " answer
        if [[ ! "$answer" =~ ^[Nn]$ ]]; then
            printf '[user]\n    name = %s\n    email = %s\n' \
                "$current_name" "$current_email" >"$target"
            info "wrote $target"
        fi
        return
    fi

    info "git identity is not configured"
    read -rp "    Git user name: " git_name
    read -rp "    Git email: " git_email
    printf '[user]\n    name = %s\n    email = %s\n' "$git_name" "$git_email" >"$target"
    info "wrote $target"
}

# --- Linking -----------------------------------------------------------------

backup_conflicts() {
    info "Backing up files that would conflict with stow"

    local package file relative target found=0
    for package in "${PACKAGES[@]}"; do
        while IFS= read -r -d '' file; do
            relative="${file#"$REPO_DIR/$package/"}"
            target="$HOME/$relative"

            [ -e "$target" ] || continue

            # Already linked: either the file itself is a symlink, or an
            # ancestor directory is one and the path resolves into the repo
            [ -L "$target" ] && continue
            [ "$(readlink -f "$target")" = "$(readlink -f "$file")" ] && continue

            mv "$target" "$target.bak.$STAMP"
            echo "    $target -> $target.bak.$STAMP"
            found=1
        done < <(find "$REPO_DIR/$package" -type f -print0)
    done

    [ "$found" -eq 0 ] && echo "    nothing to back up"
    return 0
}

link_packages() {
    info "Linking packages with stow"
    cd "$REPO_DIR"
    stow "${PACKAGES[@]}"
}

# --- tmux plugin manager -----------------------------------------------------

install_tpm() {
    local tpm_dir="$HOME/.tmux/plugins/tpm"

    if [ -d "$tpm_dir" ]; then
        info "TPM already installed"
        return
    fi

    info "Installing TPM"
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"

    # Install the plugins declared in .tmux.conf without starting a client
    "$tpm_dir/bin/install_plugins" || warn "TPM plugin install failed; run prefix+I inside tmux"
}

# --- Shell -------------------------------------------------------------------

ensure_starship() {
    if command -v starship >/dev/null; then
        info "starship already installed"
        return
    fi

    info "Installing starship from upstream"
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
}

set_default_shell() {
    local zsh_path
    zsh_path="$(command -v zsh)"

    if [ "$SHELL" = "$zsh_path" ]; then
        info "zsh is already the default shell"
        return
    fi

    info "Setting zsh as the default shell"
    chsh -s "$zsh_path"
}

# --- Neovim plugins ----------------------------------------------------------

sync_plugins() {
    info "Installing Neovim plugins (first run takes a while)"
    # restore, not sync: install exactly the versions pinned in lazy-lock.json
    nvim --headless "+Lazy! restore" +qa
}

# --- Main --------------------------------------------------------------------

main() {
    if [ "$(id -u)" -eq 0 ]; then
        echo "Run this as your normal user, not with sudo." >&2
        echo "The script calls sudo itself where needed." >&2
        exit 1
    fi

    for arg in "$@"; do
        case "$arg" in
            --desktop) INSTALL_DESKTOP=1 ;;
            *)
                echo "Unknown option: $arg" >&2
                echo "Usage: $0 [--desktop]" >&2
                exit 1
                ;;
        esac
    done

    if [ "$INSTALL_DESKTOP" -eq 1 ]; then
        PACKAGES+=("${DESKTOP_PACKAGES[@]}")
    fi

    info "Detected distribution: $DISTRO"

    install_packages
    ensure_neovim
    ensure_tree_sitter
    install_desktop
    setup_git_identity
    backup_conflicts
    link_packages
    install_tpm
    ensure_starship
    set_default_shell
    sync_plugins

    info "Done."
    echo "    Restart your shell (or log out and back in) to pick up zsh."
    if [ "$INSTALL_DESKTOP" -eq 1 ]; then
        echo "    Select the Hyprland session at the login screen."
    else
        echo "    Install a Nerd Font and select it in your terminal for icons."
    fi
}

main "$@"
