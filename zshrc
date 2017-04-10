export EDITOR=vim
alias vi="vim"
alias v="vim"
alias g="git"
set -o vi

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

bindkey  \  history-beginning-search-backward-end
bindkey  \  history-beginning-search-forward-end

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi
