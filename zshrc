# Local Config {{{
#export LOCAL_PHREPO_PATH=/Users/hongwf/Documents/repo/philia.test
#export LOCAL_MNT_PATH=/Users/hongwf/Documents/mnt
#export LOCAL_RC_CONFIG=~/.zshrc

#source ${LOCAL_PHREPO_PATH}/zshrc
# Local Config }}}
# Global Config {{{
set -o vi

export KEYTIMEOUT=1

zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# Use vim cli mode
bindkey '^P' up-history
bindkey '^N' down-history

# backspace and ^h working even after
# returning from command mode
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char

# ctrl-w removed word backwards
bindkey '^w' backward-kill-word

# ctrl-r starts searching history backward
bindkey '^r' history-incremental-search-backward

export EDITOR=vim
# Aliases {{{
alias vi="vim"
alias v="vim"
alias g='git'
alias i="echo $(whoami)@$(hostname)"
alias ll="ls -al"
alias pbc='pbcopy'
alias pbca='ansifilter | pbcopy'
alias pbp='pbpaste'

alias cdm="cd ${LOCAL_MNT_PATH}"
alias cdt="cd ${LOCAL_MNT_PATH}/tmp"
alias cdws="cd ${LOCAL_MNT_PATH}/workspace && ls"
alias cdmy="cd ${LOCAL_PHREPO_PATH}"

alias tm='tmux new-session -d -s 0 -n def \; new-window -t 0:2 -n ws \; select-window -t 0:1 \; attach \;'
alias tma='tmux attach'

# Aliases }}}
