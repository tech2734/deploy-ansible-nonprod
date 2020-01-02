HISTTIMEFORMAT=${HISTTIMEFORMAT:-"%F %H:%M:%S "}
unset TERMCAP

spwd () {
  ( IFS=/
  set $PWD
  if test $# -le 3 ; then
    echo "$PWD"
  else
    eval echo \"..\${$(($#-1))}/\${$#}\"
  fi ) ; }

if path tput hs 2>/dev/null || path tput -T $TERM+sl hs 2>/dev/null ; then
  if test "$TERM" = xterm ; then
    _tsl=$(echo -en '\e]2;')
    _isl=$(echo -en '\e]1;')
    _fsl=$(echo -en '\007')
  else
    _tsl=$(path tput tsl 2>/dev/null || path tput -T $TERM+sl tsl 2>/dev/null)
    _isl=''
    _fsl=$(path tput fsl 2>/dev/null || path tput -T $TERM+sl fsl 2>/dev/null)
  fi
  _sc=$(tput sc 2>/dev/null)
  _rc=$(tput rc 2>/dev/null)
  if test -n "$_tsl" -a -n "$_isl" -a "$_fsl" ; then
    TS1="$_sc$_tsl%s@%s:%s$_fsl$_isl%s$_fsl$_rc"
  elif test -n "$_tsl" -a "$_fsl" ; then
    TS1="$_sc$_tsl%s@%s:%s$_fsl$_rc"
  fi
  unset _isl _tsl _fsl _sc _rc

  ppwd () {
    local dir
    local -i width
    test -n "$TS1" || return;
    dir="$(dirs +0)"
    let width=${#dir}-18
    test ${#dir} -le 18 || dir="...${dir#$(printf "%.*s" $width "$dir")}"
    if test ${#TS1} -gt 17 ; then
      printf "$TS1" "$USER" "$HOST" "$dir" "$HOST"
    else
      printf "$TS1" "$USER" "$HOST" "$dir"
    fi
    }
else
  ppwd () { true; }
fi

if test "$UID" -eq 0  ; then
  if test -n "$TERM" -a -t ; then
    _bred="$(path tput bold 2> /dev/null; path tput setaf 1 2> /dev/null)"
    _sgr0="$(path tput sgr0 2> /dev/null)"
  fi
  if test -n "$_bred" -a -n "$_sgr0" ; then
    _u="\[$_bred\]\h"
    _p=" #\[$_sgr0\]"
  else
    _u="\h"
    _p=" #"
  fi
  unset _bred _sgr0
else
#  if test "$0" = "-ksh" ; then
#    _u="$(tput setaf 46)${USER}@${HOSTNAME}"
#    _p=" > $(tput sgr0)"
#  else
  _u="$(tput setaf 46)${USER}@${HOSTNAME}"
  _p=" > $(tput sgr0)"
#    _u="\u@\h"
#    _p=">"
#  fi
fi

if test -z "$EMACS" -a -z "$MC_SID" -a -z "$restricted" -a -z "$STY" -a -n "$DISPLAY" -a ! -r $HOME/.bash.expert; then
  _t="\[\$(ppwd)\]"
else
  _t=""
fi

case "$(declare -p PS1 2> /dev/null)" in
  *-x*PS1=*)
    ;;
  *)
    if test "$0" = "-ksh"; then
      PS1="${_t}${_u}:"'${PWD}'"${_p} "
    else
      PS1="${_t}${_u}:\w${_p} "
    fi
    ;;
esac

unset _u _p _t

PS2='> '
test -s /etc/profile.d/alias.bash && . /etc/profile.d/alias.bash
test -s $HOME/.alias && . $HOME/.alias

case "$BASH_VERSION" in
  [2-9].*)
    test -e /etc/bash_completion && . /etc/bash_completion
    test -s /etc/profile.d/bash_completion.sh && . /etc/profile.d/bash_completion.sh
    test -s /etc/profile.d/complete.bash && . /etc/profile.d/complete.bash
    if [[ $BASH_COMPLETION_COMPAT_DIR != /etc/bash_completion.d ]]; then
      for s in /etc/bash_completion.d/*.sh ; do
        test -r $s && . $s
      done
    fi
    test -e $HOME/.bash_completion && . $HOME/.bash_completion
    test -f /etc/bash_command_not_found && . /etc/bash_command_not_found
    ;;
  *)
    ;;
esac

HISTCONTROL=ignoreboth
