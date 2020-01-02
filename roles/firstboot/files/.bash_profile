# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs
PATH=$PATH:$HOME/bin
export PATH
set -o vi
alias less='less -M -I -R'
alias ..='cd ..'
alias ...='cd ../..'
alias beep='echo -en "\007"'
alias cd..='cd ..'
alias dir='ls -l'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ls='ls -A -N --color=tty -T 0'
alias ll='ls -l -A -N --color=tty -T 0'
alias l='ls -A -N --color=tty -T 0'
alias la='ls -A -N --color=tty -T 0'
alias ls-l='ls -l -A -N --color=tty -T 0'
alias md='mkdir -p'
alias rd='rmdir'
alias rehash='hash -r'
