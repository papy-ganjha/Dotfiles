# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
## Aliases
### Switch to x86_64 homebrew
# alias brew_switch_x86='eval "$(/opt/brew/bin/brew shellenv)"'
alias brew_switch_x86='eval "$(/usr/local/bin/brew shellenv)"'
# Switch to ARM homebrew
alias brew_switch_arm='eval "$(/opt/homebrew/bin/brew shellenv)"'
# Alias for neo vim instead of vim
alias vim='nvim'
# alias docker='vessel'

# POETRY PATH
export PATH="/Users/kenz/.local/bin:$PATH"

### GPTk
# wine-gptk(){ WINEESYNC=1 WINEPREFIX=~/Documents/SteamPrefix $(brew --prefix game-porting-toolkit)/bin/wine64 "$@"; }



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kenz/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kenz/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/kenz/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kenz/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/otr2/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/otr2/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#### Added by green-restore install-tools
autoload -Uz compinit && compinit
####
[[ -s /Users/kenz/.rsvm/rsvm.sh ]] && . /Users/kenz/.rsvm/rsvm.sh # This loads RSVM

### FZF on mac 
set rtp+=/opt/homebrew/opt/fzf

### Nice coreflow autocomplete commands with @
_coretorch() {
    if [[ ${words[CURRENT]} == @* ]]; then
        compset -P '@'
    fi
    # Only complete .yml files and directories
    _files -g "*.{cfg,yaml,yml}" -/
}


alias kget='kubectl get pods,jobs,rs,statefulset'
alias kd='kubectl describe'
alias kdq='kd quota'
alias klog='kubectl logs'
alias kdel='kubectl delete'

alias kctx='f() { kubectl config set-context --current --namespace=$1 };f'

alias ki1a='kcli init -c us-west-1a'

alias ki-mlo='ki1a && kctx mlo-data-autovqa && kget'

function kube-ssh() {
    if [ -z $1 ] ; then
        echo "Defaulting to the production app instance type (''). Pass 'dev' or 'test' for those envs."
        instance_type=""
    else
        instance_type="-$1"
    fi

        # If DEBUG is set when you run `kubectl exec`, you will get
        # very noisy data logs for network traffic.
        if [ $DEBUG ] ; then
                OLD_DEBUG=$DEBUG
                unset DEBUG
        fi

        pod_name=$(kubectl get pods -l app=ebar$instance_type-main --output jsonpath='{.items[*].metadata.name}')
        kubectl exec $pod_name -it -- /bin/bash

        if [ $OLD_DEBUG ] ; then
                DEBUG=$OLD_DEBUG
                unset OLD_DEBUG
        fi
}

function kube-update-setting-keys() {
    if [ -z $1 ] ; then
        echo "Must supply a SETTING_KEYS file as first argument"
        return 1
    fi

    #if [ $(basename $1) != "SETTING_KEYS" ] ; then
    #    echo "Must supply a SETTING_KEYS file as first argument"
    #    return 1
    #fi

    # Checks for valid json without printing the whole thing
    cat $1 | jq empty
    if [ $? -ne 0 ] ; then
        echo "${1} must be valid json"
        return 1
    fi

    secret_name=$2

    if [ -z $2 ] ; then
       secret_name="setting-keys";
    fi

    # kubectl will not let us create a secret if
    # it already exists, so we do a "dry run" and send
    # it's output to `kubectl apply -f` to force-apply
    # the change
    set -x
    kubectl create secret generic ${secret_name} \
        --save-config --dry-run=client --from-file $1 -o yaml \
        | kubectl apply -f -
}
