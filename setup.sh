brew install stow neovim tmux
stow . --adopt -t $HOME

bash ./scripts/install_tmux_nvim_config.sh
