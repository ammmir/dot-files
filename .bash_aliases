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

# set a fancy prompt
PS1='\[\e[1;10m\]\u\[\e[1;36m\]@\[\e[1;32m\]\h\[\e[1;30m\]:\[\e[0;37m\]\w\[\e[0;37m\]$ '
