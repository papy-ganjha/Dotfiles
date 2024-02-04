# Dotfiles repository

This repo is all my classic configuration. In the python folder you can find all to set up a project with python

## Symlink configuration:

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
