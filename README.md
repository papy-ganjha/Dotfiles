# Dotfiles repository

My personal dotfiles for Neovim, Tmux, Zsh, and Git configuration.

## Quick Install

Install everything with one command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/papy-ganjha/Dotfiles/main/install.sh)
```

This will automatically:
- Detect your OS (macOS or Linux)
- Install prerequisites (stow, neovim, tmux, git, curl)
- Install additional tools (ripgrep, fzf, npm, lazygit)
- Clone this repository to `~/.dotfiles`
- Symlink all configurations to your home directory
- Install TPM (Tmux Plugin Manager)
- Set up Neovim with lazy.nvim

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
