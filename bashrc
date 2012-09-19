export PS1="\e[0;32m\u\e[m@\e[1;30m\H-\e[0;36m\t\e[m\e[m:\e[0;31m\w\e[m\n\e[1;32m\\$\e[m "
export LS_COLORS="no=00:fi=00:di=01;30;44:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"

alias ls="ls --color=auto --show-control-chars"
alias ll="ls -alF --show-control-chars"
alias grep="grep --color=auto"

set -o vi

alias cdm="cd ~/mnt"
alias cdt="cd ~/mnt/tmp"
alias cdv="cd ~/mnt/var"
alias vi="vim"

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-i": complete'

cd ~/
