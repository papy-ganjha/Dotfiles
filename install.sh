#!/usr/bin/env bash

#############################################
# Dotfiles Installation Script
# Author: papy-ganjha
# Description: One-line installer for nvim and tmux configuration
#############################################

set -e  # Exit on error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print functions
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        print_info "Detected macOS"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        print_info "Detected Linux"
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew on macOS
install_homebrew() {
    if ! command_exists brew; then
        print_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        print_success "Homebrew installed"
    else
        print_info "Homebrew already installed"
    fi
}

# Install prerequisites based on OS
install_prerequisites() {
    print_info "Installing prerequisites..."

    if [[ "$OS" == "macos" ]]; then
        install_homebrew

        # Install core tools
        brew install stow neovim tmux git curl

        # Install additional dependencies
        brew install ripgrep fzf npm lazygit

    elif [[ "$OS" == "linux" ]]; then
        # Update package list
        sudo apt-get update

        # Install core tools
        sudo apt-get install -y stow neovim tmux git curl

        # Install additional dependencies
        sudo apt-get install -y ripgrep fzf npm

        # Install lazygit (not in default repos, use PPA or binary)
        if ! command_exists lazygit; then
            print_info "Installing lazygit..."
            LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
            tar xf lazygit.tar.gz lazygit
            sudo install lazygit /usr/local/bin
            rm lazygit lazygit.tar.gz
        fi
    fi

    print_success "Prerequisites installed"
}

# Clone or update dotfiles
setup_dotfiles() {
    DOTFILES_DIR="$HOME/.dotfiles"

    if [[ -d "$DOTFILES_DIR" ]]; then
        print_info "Dotfiles directory already exists at $DOTFILES_DIR"
        print_info "Updating repository..."
        cd "$DOTFILES_DIR"
        git pull origin main || print_warning "Could not update repository"
    else
        print_info "Cloning dotfiles repository..."
        git clone https://github.com/papy-ganjha/Dotfiles.git "$DOTFILES_DIR"
        cd "$DOTFILES_DIR"
    fi

    print_success "Dotfiles repository ready at $DOTFILES_DIR"
}

# Symlink configurations using stow
symlink_configs() {
    print_info "Symlinking configurations with stow..."
    cd "$DOTFILES_DIR"

    # Backup existing configs if they exist and aren't symlinks
    backup_if_exists() {
        if [[ -e "$1" && ! -L "$1" ]]; then
            print_warning "Backing up existing $1 to $1.backup"
            mv "$1" "$1.backup"
        fi
    }

    backup_if_exists "$HOME/.config/nvim"
    backup_if_exists "$HOME/.config/.tmux.conf"
    backup_if_exists "$HOME/.zshrc"
    backup_if_exists "$HOME/.gitconfig"
    backup_if_exists "$HOME/.p10k.zsh"

    # Use stow to create symlinks
    stow . --adopt -t "$HOME" 2>/dev/null || {
        print_warning "Some files may already exist. Trying to restow..."
        stow --restow . -t "$HOME"
    }

    print_success "Configurations symlinked"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
    TPM_DIR="$HOME/.tmux/plugins/tpm"

    if [[ -d "$TPM_DIR" ]]; then
        print_info "TPM already installed"
    else
        print_info "Installing TPM (Tmux Plugin Manager)..."
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
        print_success "TPM installed"
    fi
}

# Install Neovim plugins
setup_neovim() {
    print_info "Setting up Neovim..."

    # Neovim will install lazy.nvim and plugins on first launch
    print_info "Neovim will install plugins on first launch"
    print_info "Run 'nvim' and lazy.nvim will automatically install all plugins"
}

# Main installation flow
main() {
    echo ""
    echo "======================================"
    echo "  Dotfiles Installation Script"
    echo "  nvim + tmux configuration"
    echo "======================================"
    echo ""

    detect_os
    install_prerequisites
    setup_dotfiles
    symlink_configs
    install_tpm
    setup_neovim

    echo ""
    echo "======================================"
    print_success "Installation complete!"
    echo "======================================"
    echo ""
    print_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Launch tmux and press 'prefix + I' (Ctrl+Space + Shift+i) to install tmux plugins"
    echo "  3. Launch nvim - plugins will be installed automatically by lazy.nvim"
    echo ""
    print_info "Configuration locations:"
    echo "  - Dotfiles: $HOME/.dotfiles"
    echo "  - Neovim config: ~/.config/nvim/"
    echo "  - Tmux config: ~/.config/.tmux.conf"
    echo ""
}

# Run main function
main
