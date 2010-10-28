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
  PS1="\[$bold\]\[$green\]\u\[$reset\]@\[$bold\]\[$cyan\]\h\[$reset\]:\[$bold\]\[$blue\]\w\[$reset\]\$ "
}

makeprompt
