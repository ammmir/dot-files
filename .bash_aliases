# amir's aliases v1.0
alias cls='clear'

if [[ $OSTYPE = *darwin* ]]
then
  alias l='ls -lFG'
  alias ll='ls -alFG'
else
  alias l='ls -lF --color'
  alias ll='ls -alF --color'
fi

# safety
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# fun stuff
alias vi='vim -p'
alias less='less -R'
alias more='more -R'

# use colordiff if available
which colordiff > /dev/null 2>&1
if [ $? -eq 0 ]; then
  alias diff='colordiff'
else
  if [ -x ~/bin/colordiff ]; then
    alias diff='colordiff'
  fi
fi

# set a fancy prompt
makeprompt() {
  local underline=$(tput sgr 0 1)
  local bold=$(tput bold)
  local red=$(tput setaf 1)
  local green=$(tput setaf 2)
  local yellow=$(tput setaf 3)
  local blue=$(tput setaf 4)
  local purple=$(tput setaf 5)
  local cyan=$(tput setaf 6)
  local white=$(tput setaf 7)
  local reset=$(tput sgr0)

  if [[ $OSTYPE = *darwin* ]]
  then
    PS1="\[$bold\]\[$green\]\u\[$reset\]@\[$bold\]\[$cyan\]\h\[$reset\]:\[$bold\]\[$blue\]\W\[$reset\]\$ "
  else
    PS1="\[\e[1;10m\]\u\[\e[1;36m\]@\[\e[1;32m\]\h\[\e[1;30m\]:\[\e[0;37m\]\w\[\e[0;37m\]$"
  fi
}

makeprompt

#_compssh() {
#  cur=${COMP_WORDS[COMP_CWORD]};
#  COMPREPLY=($(compgen -W "$(sed -e 's/ .*$//;s/,.*//' ${HOME}/.ssh/known_hosts)" -- $cur))
#}

#complete -F _compssh ssh
#complete -F _compssh scp
#complete -F _compssh sftp

# Use bash-completion, if available
if [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# z
. ~/dot-files/z.sh
