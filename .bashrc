# If running interactively, then:
if [ "$PS1" ]; then
  # set a fancy prompt
  # PS1='\u@\h:\w\$ '
  PS1='\[\e[1;10m\]\u\[\e[1;36m\]@\[\e[1;32m\]\h\[\e[1;30m\]:\[\e[0;37m\]\w\[\e[0;37m\]$ '

  # If this is an xterm set the title to user@host:dir
  case $TERM in
  xterm*)
      PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'
      ;;
  *)
      ;;
  esac


fi

source ~/.bash_aliases
