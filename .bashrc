# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Environment Vars
export TERMINAL=alacritty
export EDITOR=vim

# Bash Completions
source /usr/share/git/completion/git-prompt.sh
source /usr/share/git/completion/git-completion.bash
source /usr/share/bash-completion/completions/git

source <(kubectl completion bash) 
complete -F __start_kubectl k  
 
export NVM_DIR="$HOME/.nvm" 
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
PURPLE='\033[0;35m'
LPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
NC='\033[0m'

# Prompt
PS1="\[$LGREEN\][\u: \[$LBLUE\]\W\[$LGREEN\]]\[$YELLOW\]\$(__git_ps1)\[$NC\]\n\$ "

# Aliases
alias d='docker'
alias k='kubectl'
alias tf='terraform'
alias wd='client-workdir'
alias ls='ls --color=auto'
alias todo='vim ~/todo.md'
alias ope='sudo "$BASH" -c "$(history -p !!)"'
alias client-code='code "$HOME/git/$(cat $HOME/.project)"'
alias open-client-dir='client-workdir "$(cat ~/.project)" && code .'
alias emu-clone='git -c core.sshCommand="ssh -i ~/.ssh/ghe_id_rsa" clone'
alias emu-pull='git -c core.sshCommand="ssh -i ~/.ssh/ghe_id_rsa" pull'
alias emu-push='git -c core.sshCommand="ssh -i ~/.ssh/ghe_id_rsa" push'
alias ibvm='qemu-system-x86_64 -cpu host -smp cores=4 -m 8G -drive file=/home/mmcmullen/ibm/fedora-35.img,format=raw -enable-kvm &'
alias simple-tracker-vm='ssh azureuser@13.92.57.173 -i ~/.ssh/simple-tracker_key.pem'
alias timecard='. /home/mmcmullen/git/misc/ibm-time/w3_creds && ibm-time'


# Functions

function citrix() { 
    dup=(~/Downloads/*\(1\).ica);
    if [ -f "$dup" ]; then
        rm "$dup";
    fi;
    file=(~/Downloads/*.ica);
    /opt/Citrix/ICAClient/wfica $file
}

function bake () { 
  ( cd ~/git/$(cat ~/.project) && make $1 )
}

function client-workdir () { 
    if [ $# -eq 0 ]; then
        echo -e "${LPURPLE}Available Working Directories:$NC";
        find /home/mmcmullen/git/ -maxdepth 1 -printf "- %f\n" -type d | tail -n +2;
    else
        cd /home/mmcmullen/git/$1;
    fi
}

function work-dir() {
  if [ $# -eq 0 ]; then
    echo -e "${LPURPLE}Available Working Directories:$NC"
    find $HOME/git/ -maxdepth 1 -printf "- %f\n" -type d | tail -n +2
  else
    herbstclient rule once monitor=1
    code ~/git/$1
    herbstclient set_layout max
    qutebrowser github.com/mbmcmullen27/$1
    herbstclient focus r
  fi
}

function kubefig () {
  if [ $# -eq 0 ]; then
    echo -e "${LPURPLE}Available Configs:$NC"
    ls -l ~/.kube | awk '{print "- "$9}' | tail -n +3
  else
    cp ~/.kube/$1 ~/.kube/config
    echo -e "${GREEN}copied ~/.kube/$1 to ~/.kube/config$NC"
  fi
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
  echo -e "${LGREEN}total:$NC ~${total}GB"
}

function docker-clean() {
  echo -e "${LPURPLE}Before:$NC"
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

  echo -e "\n${LPURPLE}After:$NC"
  docker-mem
}

function new-express() {
  npx express-generator $1 --view ejs
}

function set-workdir() { 
  pwd | awk -F'git/' '{print $2}' > ~/.project
}

# Start X Server
if [ -z "${DISPLAY}" ] && [ "${XDG_VTNR:-0}" -eq 1 ]; then
  exec startx
fi

cat ~/blinky
