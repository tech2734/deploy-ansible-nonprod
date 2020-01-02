if [ -f  "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion" ]; then
  . "${XDG_CONFIG_HOME:-$HOME/.config}/bash_completion"
fi
if [ -f "/usr/share/bash-completion/bash_completion" ]; then
  . /usr/share/bash-completion/bash_completion
fi
