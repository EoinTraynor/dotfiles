#!/usr/bin/env bash
set -e

# ==============================================================================
# Dotfiles Bootstrap Script
# Supports: macOS and Linux
# ==============================================================================

BOLD="$(tput bold 2>/dev/null || echo '')"
GREEN="$(tput setaf 2 2>/dev/null || echo '')"
BLUE="$(tput setaf 4 2>/dev/null || echo '')"
YELLOW="$(tput setaf 3 2>/dev/null || echo '')"
RESET="$(tput sgr0 2>/dev/null || echo '')"

log_info() { echo "${BLUE}${BOLD}==>${RESET} ${BOLD}$1${RESET}"; }
log_success() { echo "${GREEN}${BOLD}==>${RESET} ${GREEN}$1${RESET}"; }
log_warn() { echo "${YELLOW}${BOLD}==>${RESET} ${YELLOW}$1${RESET}"; }

# 1. Detect OS and architecture
OS="$(uname -s)"
case "$OS" in
    Darwin)
        log_info "Detected macOS."
        # Install Homebrew if not installed
        if ! command -v brew >/dev/null 2>&1; then
            log_info "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if [[ -x "/opt/homebrew/bin/brew" ]]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
        fi
        ;;
    Linux)
        log_info "Detected Linux."
        ;;
    *)
        log_warn "Unsupported operating system: $OS"
        ;;
esac

# 2. Ensure ~/.local/bin is in PATH
mkdir -p "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# 3. Install chezmoi if missing
if ! command -v chezmoi >/dev/null 2>&1; then
    log_info "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin"
    log_success "chezmoi installed to $HOME/.local/bin/chezmoi"
else
    log_info "chezmoi is already installed."
fi

# 4. Install Starship prompt if missing
if ! command -v starship >/dev/null 2>&1; then
    log_info "Installing Starship prompt..."
    sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y -b "$HOME/.local/bin"
    log_success "Starship installed to $HOME/.local/bin/starship"
else
    log_info "Starship is already installed."
fi

# 5. Initialize and apply dotfiles
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_info "Applying dotfiles with chezmoi..."
chezmoi init --source="$DOTFILES_DIR" --apply

# 6. Check for local secrets file
if [ ! -f "$HOME/.zshrc.local" ]; then
    log_warn "No ~/.zshrc.local found."
    log_info "Creating empty ~/.zshrc.local template for machine secrets..."
    cat << 'SECRET_EOF' > "$HOME/.zshrc.local"
# Machine-specific overrides and secrets (not committed to git)
# export OPENAI_API_KEY="sk-..."
# export ANTHROPIC_API_KEY="sk-ant-..."
# export GEMINI_API_KEY="..."
SECRET_EOF
    chmod 600 "$HOME/.zshrc.local"
fi

echo ""
log_success "Dotfiles setup completed successfully!"
echo "To activate your new shell, restart your terminal or run: ${BOLD}exec zsh${RESET}"
