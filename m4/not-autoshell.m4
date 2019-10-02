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



dnl  NS_SETVAR(var[, val])
dnl  **************************************************************************
dnl
dnl  M4 sugar to set the value of a shell variable
dnl
dnl  Same as `variable=value`.
dnl
dnl  Example:
dnl
dnl      NS_SETVAR([MY_MESSAGE], ['This is a test'])
dnl      AC_MSG_NOTICE([NS_GETVAR([MY_MESSAGE])])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_SETVAR], [$1=$2 ])


dnl  NS_SETVARS(var1[, val1][, var2[, val2][, ... varN[, valN]]])
dnl  **************************************************************************
dnl
dnl  M4 sugar to set the value of many shell variables at once
dnl
dnl  Same as `var1=val1 var2=val2 ... varN=valN`.
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_SETVARS],
	[$1=$2 m4_if(m4_eval([$# > 2]), [1], [NS_SETVARS(m4_shift2($@))])])


dnl  NS_GETVAR(var)
dnl  **************************************************************************
dnl
dnl  M4 sugar to get the value of a shell variable
dnl
dnl  Same as `$var`.
dnl
dnl  Example:
dnl
dnl      NS_SETVAR([MY_MESSAGE], ['This is a test'])
dnl      AC_MSG_NOTICE([My message --> NS_GETVAR([MY_MESSAGE])])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
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
dnl  instead of executing a command during the `automake` process, it executes
dnl  it during the `configure` process, when all M4 macros have been already
dnl  expanded. The returned value cannot therefore be stored in another macro,
dnl  but must be stored in a shell variable instead.
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([Today is NS_GETOUT([date])])
dnl      AC_MSG_NOTICE([NS_GETOUT([echo 'This is a test'])])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
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
dnl      NS_SETVAR([FIRST_VAR], ['first value'])
dnl      NS_SETVAR([SECOND_VAR], ['second value'])
dnl      NS_SETVAR([THIRD_VAR], ['third value'])
dnl
dnl      NS_UNSET([FIRST_VAR], [SECOND_VAR], [THIRD_VAR])
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_UNSET],
	[m4_ifnblank([$1], [AS_UNSET([$1]);])m4_if([$#], [1], [], [NS_UNSET(m4_shift($@))])])



dnl  **************************************************************************
dnl  Note:  The `NS_` prefix (which stands for "Not autoShell") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

