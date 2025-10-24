# Dotfiles repository

My personal dotfiles for Neovim, Tmux, Zsh, and Git configuration.

## Quick Install

**After merging to main**, install everything with one command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/papy-ganjha/Dotfiles/main/install.sh)
```

**Note**: The script is currently on branch `benz/one-line-install-script`. You'll get a 404 error until you push and merge to main. For testing before merge, use:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/papy-ganjha/Dotfiles/benz/one-line-install-script/install.sh)
```

### What the installer does:
- Detects your OS (macOS or Linux)
- **Creates a timestamped backup** of existing configs (with restore script)
- Installs prerequisites (stow, neovim, tmux, git, curl)
- Installs additional tools (ripgrep, fzf, npm, lazygit)
- Clones this repository to `~/.dotfiles`
- Symlinks all configurations to your home directory
- Installs TPM (Tmux Plugin Manager)
- Sets up Neovim with lazy.nvim

### Backup & Restore

The installer automatically creates backups before making changes:
- Backups are stored in `~/.dotfiles-backup-TIMESTAMP/`
- A restore script is created: `~/.dotfiles-backup-TIMESTAMP/restore.sh`
- To restore your old configs: `bash ~/.dotfiles-backup-TIMESTAMP/restore.sh`

## What's Included

- **Neovim**: Full IDE setup with lazy.nvim plugin manager (`~/.config/nvim/`)
- **Tmux**: Terminal multiplexer configuration (`~/.config/.tmux.conf`)
- **Zsh**: Shell configuration with Powerlevel10k theme (`~/.zshrc`, `~/.p10k.zsh`)
- **Git**: Git aliases and configuration (`~/.gitconfig`)

## Post-Installation

After installation:
1. Restart your terminal or run: `source ~/.zshrc`
2. Launch tmux and press `Ctrl+Space` + `Shift+i` to install tmux plugins
3. Launch nvim - plugins will be installed automatically

## Manual Installation

### MacOS setup:
install brew in you're way. For public brew launch this command:
`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

Next you have to install `stow` with the folowing command: `brew install stow`

And then to use the symlink with stow please launch the following command: `stow . --adopt -t $HOME`

### Ubuntu setup:

To configure a symlink on ubuntu you need to pass this command:

```
ln -s path/of/the/file path/of/the/symlink/location
```
