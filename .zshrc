# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load Powerlevel10k theme
zinit ice depth=1
zinit light romkatv/powerlevel10k

# Load oh-my-zsh library (for compatibility with omz plugins)
zinit snippet OMZL::git.zsh

# Load oh-my-zsh plugins
zinit snippet OMZP::git
zinit snippet OMZP::web-search

# Load fast-syntax-highlighting (with turbo mode for faster startup)
zinit ice wait lucid atinit"zicompinit; zicdreplay"
zinit light zdharma-continuum/fast-syntax-highlighting

# Load zsh-autosuggestions
zinit ice wait lucid atload"_zsh_autosuggest_start"
zinit light zsh-users/zsh-autosuggestions

# History search with arrow keys (search for commands matching what you've typed)
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search    # Up arrow
bindkey "^[[B" down-line-or-beginning-search  # Down arrow

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
# compinit now handled by zinit
####
[[ -s /Users/kenz/.rsvm/rsvm.sh ]] && . /Users/kenz/.rsvm/rsvm.sh # This loads RSVM

### FZF on mac
set rtp+=/opt/homebrew/opt/fzf

### Performance: Clean up orphaned gitstatusd processes
# These accumulate over time from P10k and cause terminal lag
# This function kills gitstatusd processes older than 1 day
cleanup_old_gitstatusd() {
  # Find and kill gitstatusd processes older than 1 day (86400 seconds)
  pgrep -f gitstatusd | while read pid; do
    # Get process age in seconds
    local age=$(ps -p $pid -o etime= 2>/dev/null | awk -F'[:-]' '{
      if (NF == 4) print ($1*86400 + $2*3600 + $3*60 + $4);
      else if (NF == 3) print ($1*3600 + $2*60 + $3);
      else if (NF == 2) print ($1*60 + $2);
      else print $1;
    }')
    # Kill if older than 1 day
    if [[ $age -gt 86400 ]]; then
      kill $pid 2>/dev/null
    fi
  done
}

# Run cleanup on shell startup (runs once per shell session)
cleanup_old_gitstatusd &>/dev/null

# Kube aliases
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
