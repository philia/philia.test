export PS1="\e[0;32m\u\e[m@\e[1;30m\H-\e[0;36m\t\e[m\e[m:\e[0;31m\w\e[m\n\e[1;32m\\$\e[m "

alias ll="ls -alF"
alias grep="grep --color=auto"

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-i": complete'

set -o vi
