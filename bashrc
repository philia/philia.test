# CentOS
#export PS1="\e[32;1m\]\u@\e[30;1m\]\H-\e[36;1m\]\d \t:\e[31;1m\]\w\e[37;1m\]\n\$ "
# Ubuntu
#export PS1="\e[32;1m\u@\e[30;1m\H-\e[36;1m\d \t:\e[31;1m\w\e[37;1m\n\$ "
# Mac
#export PS1="\u@\d \t:\w\n\$ "
export LS_COLORS="no=00:fi=00:di=01;30;44:ln=00;36:pi=40;33:so=00;35:bd=40;33;01:cd=40;33;01:or=01;05;37;41:mi=01;05;37;41:ex=00;32:*.cmd=00;32:*.exe=00;32:*.com=00;32:*.btm=00;32:*.bat=00;32:*.sh=00;32:*.csh=00;32:*.tar=00;31:*.tgz=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.zip=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.bz=00;31:*.tz=00;31:*.rpm=00;31:*.cpio=00;31:*.jpg=00;35:*.gif=00;35:*.bmp=00;35:*.xbm=00;35:*.xpm=00;35:*.png=00;35:*.tif=00;35:"
export EDITOR=vim
export TERM=xterm-256color
## for mosh to work on OSX terminal
#export LC_ALL=en_US.UTF-8
#export LANG=en_US.UTF-8

alias ls="ls --color=auto --show-control-chars"
alias ll="ls -alF --show-control-chars"
alias grep="grep --color=auto"
alias egrep="egrep --color=auto"
alias wget="wget -c"

alias cdm="cd ~/mnt"
alias cdt="cd ~/mnt/tmp"
alias cdv="cd ~/mnt/var"
alias cdp="cd ~/mnt/var/github/philia.test"
alias vi="vim"
alias v="vim"
alias g="git"
#alias tm="tmux -2 -f ~/work/var/github/philia.test/tmux.conf attach"
alias sysupd="apt-get update && apt-get -y upgrade && apt-get -y dist-upgrade"
#/etc/hosts 104.224.158.111 bandwagon
alias ssh.bandwagon='ssh root@104.224.158.111 -p29472'
alias mosh.bandwagon='mosh --ssh="ssh -p29472" root@104.224.158.111'

set -o vi

bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
bind '"\C-i": complete'

if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

#!important! DONOT add this in bashrc
# Got "No such file or folder" error once when trying to ./somescript.sh because of this
#cd ~/
