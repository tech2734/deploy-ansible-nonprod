# .bashrc

if [ -f '/etc/bash.bashrc' ]; then
  . '/etc/bash.bashrc'
elif [ -f '/etc/bashrc' ]; then
  . '/etc/bashrc'
fi

test -s /etc/profile.d/colorls.sh && . /etc/profile.d/colorls.sh
test -s /etc/profile.d/colorgrep.sh && . /etc/profile.d/colorgrep.sh
test -s /etc/profile.d/lscolor.sh && . /etc/profile.d/lscolor.sh
test -s /etc/profile.d/alias.sh && . /etc/profile.d/alias.sh
test -s /etc/profile.d/vim.sh && . /etc/profile.d/vim.sh

case "$BASH_VERSION" in
  [2-9].*)
    test -e '/etc/bash_completion' && . '/etc/bash_completion'
    test -s '/etc/profile.d/bash_completion.sh' && . '/etc/profile.d/bash_completion.sh'
    test -e "$HOME/.bash_completion" && . "$HOME/.bash_completion"
    test -f '/etc/bash_command_not_found'  && . '/etc/bash_command_not_found'
    if [[ $BASH_COMPLETION_COMPAT_DIR != /etc/bash_completion.d ]]; then
      for s in /etc/bash_completion.d/*.sh ; do
        test -r "${s}" && . "${s}"
      done
    fi
    ;;
  *)
    ;;
esac

path ()
{
    if test -x /root/bin/$1 ; then
        ${1+"/root/bin/$@"}
    elif test -x "/usr/bin/$1" ; then
        ${1+"/usr/bin/$@"}
    elif test -x /usr/sbin/$1 ; then
        ${1+"/usr/sbin/$@"}
    elif test -x /bin/$1 ; then
        ${1+"/bin/$@"}
    elif test -x /sbin/$1 ; then
        ${1+"/sbin/$@"}
    elif test -x "/usr/local/bin/$1" ; then
        ${1+"/usr/local/bin/$@"}
    elif test -x /usr/local/sbin/$1 ; then
        ${1+"/usr/local/sbin/$@"}
    fi
}

PATH="/bin:/sbin:$PATH"
export PATH

if [ -f '/etc/inputrc' ]; then
  INPUTRC='/etc/inputrc'
  export INPUTRC
fi

for dir in '/usr/local/share/man' '/usr/local/man' '/usr/share/man'; do
  test -d $dir && MANPATH=$MANPATH:$dir
done

unset dir
export MANPATH

if test \( -n "$SSH_CONNECTION" -o -n "$SUDO_COMMAND" \) -a -z "$PROFILEREAD" ; then
  _SOURCED_FOR_SSH=true
  . '/etc/profile' > '/dev/null' 2>&1
  unset _SOURCED_FOR_SSH
fi

if test -t && type -p tty > '/dev/null' 2>&1 ; then
  GPG_TTY="`tty`"
  export GPG_TTY
fi

TERM=xterm-256color
export TERM

shopt -s checkwinsize
shopt -s histappend

HISTTIMEFORMAT=${HISTTIMEFORMAT:-"%F %H:%M:%S "}
unset TERMCAP

PS2='> '
export PS2

HISTCONTROL='ignoreboth'
export HISTCONTROL

HISTSIZE='10000'
export HISTSIZE

LS_COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.xz=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'
export LS_COLORS

COLORS='no=00:fi=00:di=01;34:ln=00;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=41;33;01:ex=00;32:*.cmd=00;32:*.exe=01;32:*.com=01;32:*.bat=01;32:*.btm=01;32:*.dll=01;32:*.tar=00;31:*.tbz=00;31:*.tgz=00;31:*.rpm=00;31:*.deb=00;31:*.arj=00;31:*.taz=00;31:*.lzh=00;31:*.lzma=00;31:*.zip=00;31:*.zoo=00;31:*.z=00;31:*.Z=00;31:*.gz=00;31:*.bz2=00;31:*.tb2=00;31:*.tz2=00;31:*.tbz2=00;31:*.xz=00;31:*.avi=01;35:*.bmp=01;35:*.fli=01;35:*.gif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mng=01;35:*.mov=01;35:*.mpg=01;35:*.pcx=01;35:*.pbm=01;35:*.pgm=01;35:*.png=01;35:*.ppm=01;35:*.tga=01;35:*.tif=01;35:*.xbm=01;35:*.xpm=01;35:*.dl=01;35:*.gl=01;35:*.wmv=01;35:*.aiff=00;32:*.au=00;32:*.mid=00;32:*.mp3=00;32:*.ogg=00;32:*.voc=00;32:*.wav=00;32:'
export COLORS

LANG='POSIX'
export LANG

LESS_ADVANCED_PREPROCESSOR='no'
export LESS_ADVANCED_PREPROCESSOR

LC_CTYPE='en_US.UTF-8'
export LC_CTYPE

COLORTERM=1
export COLORTERM

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
alias more='more -sl'
alias vi='vim'
#alias ssh='ssh -q -o StrictHostKeyChecking=no -o ConnectTimeout=5'

test -s /etc/profile.d/colorls.sh && . /etc/profile.d/colorls.sh
test -s /etc/profile.d/colorgrep.sh && . /etc/profile.d/colorgrep.sh
test -s /etc/profile.d/lscolor.sh && . /etc/profile.d/lscolor.sh
test -s /etc/profile.d/ps1.sh && . /etc/profile.d/ps1.sh
test -s /etc/profile.d/alias.sh && . /etc/profile.d/alias.sh
test -s /etc/profile.d/vim.sh && . /etc/profile.d/vim.sh
