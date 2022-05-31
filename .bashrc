source ~/.cool-prompt/bashrc-functions.sh
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export TERMINAL=alacritty
export EDITOR=vim

source ~/.git-prompt.sh
source /usr/share/bash-completion/completions/git

PS1='[\u: \W]$(__git_ps1 " ⇵ %s")\n$'

alias ls='ls --color=auto'
alias battery='cat /sys/class/power_supply/BAT0/capacity'
alias mflop='sudo mount /dev/sdb /media/floppy'
alias uflop='sudo umount /media/floppy'
alias k='kubectl'
alias d='docker'
alias ope='sudo "$BASH" -c "$(history -p !!)"'

function opp() {
  herbstclient rule once monitor=1
  code ~/git/$1
  herbstclient set_layout max
  qutebrowser github.com/mbmcmullen27/$1
  herbstclient focus r
}

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  exec startx
fi

cat ~/blinky

export PS1=$(get-config PS1)
