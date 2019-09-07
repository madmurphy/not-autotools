dnl  ***************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl            A collection of useful m4-ish macros for GNU Autotools
dnl
dnl                                               -- Released under GNU LGPL3 --
dnl
dnl                                   https://github.com/madmurphy/not-autotools
dnl  ***************************************************************************



dnl  ***************************************************************************
dnl  S H E L L - A G N O S T I C   M 4   A B S T R A C T I O N S
dnl  ***************************************************************************



dnl  NS_SETVAR(variable[, value])
dnl  ***************************************************************************
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
dnl
dnl  ***************************************************************************
AC_DEFUN([NS_SETVAR], [$1=$2])


dnl  NS_GETVAR(variable)
dnl  ***************************************************************************
dnl
dnl  M4 sugar to get the value of a shell variable
dnl
dnl  Same as `$variable`.
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
dnl
dnl  ***************************************************************************
AC_DEFUN([NS_GETVAR], [@S|@{$1}])


dnl  NS_GETOUT(command)
dnl  ***************************************************************************
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
dnl
dnl  ***************************************************************************
AC_DEFUN([NS_GETOUT], [@S|@@{:@$1@:}@])



dnl  ***************************************************************************
dnl  Note:  The `NS_` prefix (which stands for "Not autoShell") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  ***************************************************************************


dnl  EOF

