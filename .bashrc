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

if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  exec startx
fi

function opp() {
  herbstclient rule once monitor=1
  code ~/git/$1
  herbstclient set_layout max
  qutebrowser github.com/mbmcmullen27/$1
  herbstclient focus r
}

function docker-mem () {
  let mbsum=0
  let gbsum=0
  let total=0

  for i in $(docker images | grep -oP "[0-9]*(?=MB)"); do
    let "mbsum = $mbsum+$i";
  done

  for i in $(docker images | grep -oP "[0-9]*(?=GB)"); do
    let "gbsum = $gbsum+$i";
  done

  let "gbs = $mbsum / 1000"
  let "total = $gbs + $gbsum"
  echo "${mbsum}MB"
  echo "${gbsum}GB"
  echo "total: ~${total}GB"
}

docker-clean() {
  echo "Before:"
  docker-mem

  pattern="^<none>.*$"

  if [ $# -gt 0 ]; then
    pattern=$1
  fi

  ids=$(docker images | grep $pattern | awk "{print \$3}")

  for i in $ids; do
    # echo $i
    docker rmi -f $i;
  done

  echo -e "\nAfter:"
  docker-mem
}

alpine () {
  kubectl run -it --rm alpine-$USER --image=alpine -- /bin/sh
}

# run gitlab 
gitlab-start () { 
  export GITLAB_HOME="/home/mmcmullen/gitlab" 
  docker run --detach \ 
    --hostname "gitlab.local.com" \ 
    --publish 443:443 --publish 80:80 --publish 22:22 \ 
    --name gitlab \ 
    --restart always \ 
    --volume $GITLAB_HOME/config:/etc/gitlab \ 
    --volume $GITLAB_HOME/logs:/var/log/gitlab \ 
    --volume $GITLAB_HOME/data:/var/opt/gitlab \ 
    gitlab/gitlab-ee:latest 
} 

source <(kubectl completion bash) 
complete -F __start_kubectl k  
 
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

cat ~/blinky
