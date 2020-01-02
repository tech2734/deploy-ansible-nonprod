case "$-" in
*i*)
  if test -x /usr/bin/dircolors ; then
    if test -f $HOME/.dir_colors ; then
      eval "`/usr/bin/dircolors -b $HOME/.dir_colors`"
    elif test -f /etc/DIR_COLORS.256color ; then
      eval "`/usr/bin/dircolors -b /etc/DIR_COLORS`"
    elif test -f /etc/DIR_COLORS ; then
      eval "`/usr/bin/dircolors -b /etc/DIR_COLORS`"
    fi
  fi

  if test "${LS_COLORS+empty}" = "${LS_COLORS:+empty}" ; then
    LS_OPTIONS=--color=all
  else
    LS_OPTIONS=--color=none
  fi
  if test "$UID" = 0 ; then
    LS_OPTIONS="-A -N $LS_OPTIONS -T 0"
  else
    LS_OPTIONS="-N $LS_OPTIONS -T 0"
  fi

  if test "$EMACS" = "t" ; then
    LS_OPTIONS='-N --color=none -T 0';
  fi

  export LS_OPTIONS

  if test "$is" != "ash" ; then
    unalias ls 2>/dev/null
  fi
  case "$is" in
    bash|dash|ash)
      _ls ()
      {
        local IFS=' '
        command ls $LS_OPTIONS ${1+"$@"}
      }
      alias ls=_ls
      ;;
    zsh)
      test -s /etc/profile.d/ls.zsh && . /etc/profile.d/ls.zsh
      ;;
    ksh)
      _ls ()
      {
        typeset IFS=' '
        command ls $LS_OPTIONS ${1+"$@"}
      }
      alias ls=_ls
      ;;
    *)  alias ls='/bin/ls $LS_OPTIONS' ;;
  esac
  alias dir='ls -l'
  alias ls='ls -A -N --color=tty -T 0'
  alias ll='ls -l -A -N --color=tty -T 0'
  alias l='ls -A -N --color=tty -T 0'
  alias la='ls -A -N --color=tty -T 0'
  alias ls-l='ls -l -A -N --color=tty -T 0'
  ;;
esac
