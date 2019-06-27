# Local Config {{{
#export LOCAL_PHREPO_PATH=/Users/hongwf/Documents/repo/philia.test
#export LOCAL_MNT_PATH=/Users/hongwf/Documents/mnt
#export LOCAL_RC_CONFIG=~/.zshrc

#source ${LOCAL_PHREPO_PATH}/zshrc
# Local Config }}}
# Global Config {{{
set -o vi

export EDITOR='vim -u NONE'
export TERM=xterm-256color

bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# Better searching in command mode
bindkey -M vicmd '?' history-incremental-search-backward
bindkey -M vicmd '/' history-incremental-search-forward

# Beginning search with arrow keys
#bindkey "^[OA" up-line-or-beginning-search
#bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# Easier, more vim-like editor opening
bindkey -M vicmd v edit-command-line

# `v` is already mapped to visual mode, so we need to use a different key to
# open Vim
bindkey -M vicmd "^V" edit-command-line

# Make Vi mode transitions faster (KEYTIMEOUT is in hundredths of a second)
export KEYTIMEOUT=1

zle -N zle-keymap-select

# define right prompt, regardless of whether the theme defined it
RPS1='$(vi_mode_prompt_info)'
RPS2=$RPS1

# Global Config}}}
# Functions {{{
# Updates editor information when the keymap changes.
function zle-keymap-select() {
      zle reset-prompt
            zle -R
}


function vi_mode_prompt_info() {
      echo "${${KEYMAP/vicmd/[% NORMAL]%}/(main|viins)/[% INSERT]%}"
}

function _go_up_multiple_directory_levels() {
    # default parameter to 1 if non provided
    declare -i d=${@:-1}
    # ensure given parameter is non-negative. Print error and return if it is
    (( $d < 0 )) && (>&2 echo "up: Error: negative value provided") && return 1;
     # remove last d directories from pwd, append "/" in case result is empty
    cd "$(pwd | sed -E 's;(/[^/]*){0,'$d'}$;;')/";
}
# Functions }}}
# Aliases {{{
alias vi="vim"
alias v="vim"
alias g='git'
alias z='zsh'
alias i="echo $(whoami)@$(hostname)"
alias ll="ls -al"
alias ip='ipython'
alias xv='xargs -o vim'
alias pbc='pbcopy'
alias pbca='ansifilter | pbcopy'
alias pbp='pbpaste'
alias sedn=_sed_print_line
alias ncp='nc localhost 11988'
alias rc.reload="source ${LOCAL_RC_CONFIG}" && export PATH="$(perl -e 'print join(":", grep { not $seen{$_}++ } split(/:/, $ENV{PATH}))')"
alias rr=rc.reload

alias cdm="cd ${LOCAL_MNT_PATH}"
alias cdt="cd ${LOCAL_MNT_PATH}/tmp"
alias cdws="cd ${LOCAL_MNT_PATH}/workspace && ls"
alias cdmy="cd ${LOCAL_PHREPO_PATH}"
alias up=_go_up_multiple_directory_levels

# Aliases }}}
