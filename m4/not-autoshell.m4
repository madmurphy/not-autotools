dnl  **************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl            A collection of useful m4-ish macros for GNU Autotools
dnl
dnl                                               -- Released under GNU GPL3 --
dnl
dnl                                  https://github.com/madmurphy/not-autotools
dnl  **************************************************************************



dnl  **************************************************************************
dnl  S H E L L - A G N O S T I C   M 4   A B S T R A C T I O N S
dnl  **************************************************************************



dnl  NS_SETVARS(var1[, val1][, var2[, val2][, ... varN[, valN]]])
dnl  **************************************************************************
dnl
dnl  M4 sugar to set the value of many shell variables altogether
dnl
dnl  Same as `var1=val1 var2=val2 ... varN=valN`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_SETVARS],
	[AS_VAR_SET([$1], [$2]); m4_if(m4_eval([$# > 2]), [1],
		[NS_SETVARS(m4_shift2($@))])])


dnl  NS_GETVAR(var)
dnl  **************************************************************************
dnl
dnl  M4 sugar to get the value of a shell variable
dnl
dnl  Same as `$var`.
dnl
dnl  Example:
dnl
dnl      NS_SETVARS([MY_MESSAGE], ['This is a test'])
dnl      AC_MSG_NOTICE([My message --> NS_GETVAR([MY_MESSAGE])])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_GETVAR], [@S|@{$1}])


dnl  NS_GETOUT(command)
dnl  **************************************************************************
dnl
dnl  M4 sugar to get the output of a command
dnl
dnl  Same as `$(command)`. This macro works exactly like `m4_esyscmd()`, but
dnl  instead of executing a command during the `autoreconf` process, it
dnl  executes it during the `configure` process, when all M4 macros have been
dnl  already expanded. The returned value cannot therefore be stored in another
dnl  macro, but must be stored in a shell variable instead.
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([Today is NS_GETOUT([date])])
dnl      AC_MSG_NOTICE([NS_GETOUT([echo 'This is a test'])])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_GETOUT], [@S|@@{:@$1@:}@])


dnl  NS_UNSET(var1[, var2[, var3[, ... varN]]])
dnl  **************************************************************************
dnl
dnl  Like `AS_UNSET()`, but it allows to unset many variables altogether
dnl
dnl  For example:
dnl
dnl      NS_SETVARS([FIRST_VAR], ['first value'],
dnl          [SECOND_VAR], ['second value'],
dnl          [THIRD_VAR], ['third value'])
dnl
dnl      NS_UNSET([FIRST_VAR], [SECOND_VAR], [THIRD_VAR])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_UNSET],
	[m4_ifnblank([$1], [AS_UNSET(m4_quote(m4_normalize([$1])));])m4_if([$#], [1], [], [NS_UNSET(m4_shift($@))])])


dnl  NS_MOVEVAR(destination, source)
dnl  **************************************************************************
dnl
dnl  Copies the value of `source` into the shell variable `destination`, then
dnl  unsets `source` if this is set
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_MOVEVAR],
	[{ AS_VAR_COPY([$1], [$2]); AS_UNSET([$2]); }])


dnl  NS_REPLACEVAR(destination, source)
dnl  **************************************************************************
dnl
dnl  If `source` is set, copies the value of `source` into the shell variable
dnl  `destination` then unsets `source`; if `source` is not set but
dnl  `destination` is set, unsets `destination`
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_REPLACEVAR],
	[{ @S|@{$2+:} false && { AS_VAR_COPY([$1], [$2]); AS_UNSET([$2]); } || AS_UNSET([$1]) }])


dnl  NS_FOR(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create a "for" shell loop
dnl
dnl  For example:
dnl
dnl      # Iterate over all `configure` arguments and check if `--docdir` has
dnl      # been given
dnl      NS_FOR([_this_arg_],
dnl          [AS_CASE([${_this_arg_}], [--docdir=*], [
dnl              AS_VAR_SET([is_auto_docdir], [no])
dnl              NS_BREAK
dnl          ])])
dnl
dnl      AS_IF([test "x${is_auto_docdir}" != xno],
dnl          [AC_MSG_NOTICE([Using default value for <docdir>])],
dnl          [AC_MSG_NOTICE([Using user-given value for <docdir>])])
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_FOR],
	[{ for $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_WHILE(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create a "while" shell loop
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_WHILE],
	[{ while $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_UNTIL(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create an "until" shell loop
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_UNTIL],
	[{ until $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_BREAK
dnl  **************************************************************************
dnl
dnl  M4 sugar that expands to to a shell "break" command, to be used within
dnl  loops
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
AC_DEFUN([NS_BREAK],
	[m4_newline()break;m4_newline()])


dnl  NS_CONTINUE
dnl  **************************************************************************
dnl
dnl  M4 sugar that expands to to a shell "continue" command, to be used within
dnl  loops
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
AC_DEFUN([NS_CONTINUE],
	[m4_newline()continue;m4_newline()])



dnl  **************************************************************************
dnl  NOTE:  The `NS_` prefix (which stands for "Not autoShell") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

