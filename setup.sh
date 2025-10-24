brew install stow neovim tmux
stow . --adopt -t $HOME --ignore='.gitconfig' --ignore='.zshrc'

bash ./scripts/install_tmux_nvim_config.sh
