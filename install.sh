#!/usr/bin/env bash

#############################################
# Dotfiles Installation Script
# Author: papy-ganjha
# Description: One-line installer for nvim and tmux configuration
#############################################

set -e  # Exit on error

# Backup directory with timestamp
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
BACKUP_CREATED=false

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

# Create backup directory
create_backup_dir() {
    if [[ ! -d "$BACKUP_DIR" ]]; then
        mkdir -p "$BACKUP_DIR"
        BACKUP_CREATED=true
        print_info "Created backup directory: $BACKUP_DIR"
    fi
}

# Backup a file or directory and remove it
backup_item() {
    local item="$1"
    local item_name=$(basename "$item")

    if [[ -e "$item" && ! -L "$item" ]]; then
        create_backup_dir
        print_info "Backing up: $item"
        if cp -r "$item" "$BACKUP_DIR/$item_name" 2>/dev/null; then
            print_info "  ✓ Backup successful"
            # Immediately remove after successful backup
            if rm -rf "$item" 2>/dev/null; then
                print_info "  ✓ Original removed"
            else
                print_warning "  ⚠ Could not remove original, will try again later"
            fi
            return 0
        else
            print_error "  ✗ Backup failed for $item"
            return 1
        fi
    elif [[ -L "$item" ]]; then
        print_info "Removing symlink: $item"
        rm -f "$item" 2>/dev/null
        return 0
    fi
    return 1
}

# Create restore script
create_restore_script() {
    if [[ "$BACKUP_CREATED" == true ]]; then
        local restore_script="$BACKUP_DIR/restore.sh"

        cat > "$restore_script" <<'EOF'
#!/usr/bin/env bash
# Restore script for dotfiles backup

set -e

BACKUP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "This will restore your backed up configuration files."
echo "Backup location: $BACKUP_DIR"
echo ""
echo "WARNING: This will remove current symlinks and restore original files."
read -p "Are you sure you want to restore? (yes/no): " -r
echo

if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
    echo "Restore cancelled."
    exit 0
fi

# Restore each backed up file
for item in "$BACKUP_DIR"/*; do
    if [[ -f "$item" || -d "$item" ]]; then
        item_name=$(basename "$item")

        # Skip the restore script itself
        if [[ "$item_name" == "restore.sh" ]]; then
            continue
        fi

        # Determine target location
        if [[ "$item_name" == "nvim" ]]; then
            target="$HOME/.config/nvim"
        elif [[ "$item_name" == ".tmux.conf" ]]; then
            target="$HOME/.config/.tmux.conf"
        else
            target="$HOME/$item_name"
        fi

        echo "Restoring: $target"

        # Remove existing file/symlink
        if [[ -e "$target" || -L "$target" ]]; then
            rm -rf "$target"
        fi

        # Restore original
        cp -r "$item" "$target"
    fi
done

echo ""
echo "Restore completed successfully!"
echo "You may want to restart your terminal."
EOF

        chmod +x "$restore_script"
        print_success "Created restore script: $restore_script"
    fi
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

# Backup existing configurations
backup_configs() {
    print_info "Backing up existing configurations..."

    local configs_to_backup=(
        "$HOME/.config/nvim"
        "$HOME/.config/.tmux.conf"
        "$HOME/.tmux.conf"
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.p10k.zsh"
        "$HOME/.luarc.json"
    )

    local backed_up_count=0

    for config in "${configs_to_backup[@]}"; do
        if backup_item "$config"; then
            ((backed_up_count++))
        fi
    done

    # Also backup any .backup files from previous installations
    for config in "${configs_to_backup[@]}"; do
        if [[ -e "$config.backup" ]]; then
            print_info "Found old backup file: $config.backup"
            if backup_item "$config.backup"; then
                ((backed_up_count++))
            fi
        fi
    done

    if [[ $backed_up_count -gt 0 ]]; then
        print_success "Backed up $backed_up_count configuration file(s)"
        create_restore_script
    else
        print_info "No existing configurations to backup"
    fi
}

# Symlink configurations using stow
symlink_configs() {
    print_info "Symlinking configurations with stow..."
    cd "$DOTFILES_DIR"

    # Remove existing files/dirs that were backed up to allow stow to work
    local items_to_remove=(
        "$HOME/.config/nvim"
        "$HOME/.config/.tmux.conf"
        "$HOME/.tmux.conf"
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.p10k.zsh"
        "$HOME/.luarc.json"
    )

    print_info "Removing backed up files to prepare for symlinking..."

    # Temporarily disable exit on error for removal
    set +e

    for item in "${items_to_remove[@]}"; do
        if [[ -L "$item" ]]; then
            print_info "  Removing existing symlink: $item"
            rm -f "$item"
        elif [[ -e "$item" ]]; then
            print_info "  Removing: $item"
            if rm -rf "$item" 2>/dev/null; then
                print_info "    ✓ Successfully removed"
            else
                print_error "    ✗ Failed to remove $item"
            fi
        fi

        # Also remove any .backup files
        if [[ -e "$item.backup" ]]; then
            print_info "  Removing old backup: $item.backup"
            rm -rf "$item.backup" 2>/dev/null
        fi
    done

    # Re-enable exit on error
    set -e

    # Verify files are removed
    print_info "Verifying removal..."
    local conflicts=()
    for item in "${items_to_remove[@]}"; do
        if [[ -e "$item" ]]; then
            conflicts+=("$item")
            print_warning "  ⚠ Still exists: $item"
        fi
    done

    if [[ ${#conflicts[@]} -gt 0 ]]; then
        print_error "Failed to remove the following files:"
        for conflict in "${conflicts[@]}"; do
            echo "  - $conflict"
        done
        print_info ""
        print_info "These files have been backed up to: $BACKUP_DIR"
        print_info "To proceed, manually remove these files or use: rm -rf [file]"
        exit 1
    fi

    print_success "All files successfully removed"

    # Use stow to create symlinks
    print_info "Running stow to create symlinks..."
    if stow . -t "$HOME" -v 2>&1; then
        print_success "Configurations symlinked successfully"
    else
        print_error "Stow failed. This shouldn't happen as all conflicts were removed."
        print_info "You can try manually: cd $DOTFILES_DIR && stow . -t $HOME"
        exit 1
    fi
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
    backup_configs
    symlink_configs
    install_tpm
    setup_neovim

    echo ""
    echo "======================================"
    print_success "Installation complete!"
    echo "======================================"
    echo ""

    if [[ "$BACKUP_CREATED" == true ]]; then
        print_info "Backup Information:"
        echo "  - Backup location: $BACKUP_DIR"
        echo "  - To restore backups, run: bash $BACKUP_DIR/restore.sh"
        echo ""
    fi

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
