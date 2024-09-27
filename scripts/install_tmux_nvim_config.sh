# Install neovim needs for all packages
brew install rg fzf npm

#TPM Plugin manager for tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cp ../install_scripts/.tmux.conf ~/
