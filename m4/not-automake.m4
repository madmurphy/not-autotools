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
dnl  A   L O O K   I N T O   T H E   A U T O M A K E   P R O C E S S
dnl  **************************************************************************



dnl  NM_GET_AM_VAR(variable)
dnl  **************************************************************************
dnl
dnl  Retrieves an environment variable present during the `automake` process
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([This package has been distributed by NM_GET_AM_VAR([USER]).])
dnl
dnl  Note that `automake` runs at a different time (and often even on a
dnl  different computer) than the `configure` script.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NM_GET_AM_VAR], [m4_esyscmd_s([echo ${$1}])])


dnl  NM_ENVIRONMENT_KEYS
dnl  **************************************************************************
dnl
dnl  Reads all the environment variables present during the `automake` process
dnl  and returns a comma-separated list of their names
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([This package has been distributed by n4_case_in([USER],
dnl      	[NM_ENVIRONMENT_KEYS],
dnl      		[NM_GET_AM_VAR([USER])],
dnl      		[unknown])])
dnl
dnl  For the `n4_case_in()` macro, see `not-m4sugar.m4`.
dnl
dnl  Note that `automake` runs at a different time (and often even on a
dnl  different computer) than the `configure` script.
dnl
dnl  To iterate through the `NM_ENVIRONMENT_KEYS` list you can also use GNU
dnl  M4sugar looping utilities, like the `m4_map()` macro in the following
dnl  example:
dnl
dnl      AC_DEFUN([MY_MACRO], [AC_MSG_NOTICE([Found $1 among the environment variables]);])
dnl      m4_map([MY_MACRO], [NM_ENVIRONMENT_KEYS])
dnl
dnl  See:
dnl  https://www.gnu.org/software/autoconf/manual/autoconf-2.69/html_node/Looping-constructs.html
dnl
dnl  This macro makes a system call the first time it is invoked, then
dnl  overwrites itself with the literal list of the environment keys received,
dnl  so that any further access to the list will rely on a cache and not
dnl  anymore on system calls. If you want to force further system calls after
dnl  the first access you can use:
dnl
dnl      m4_popdef([NM_ENVIRONMENT_KEYS])
dnl      NM_ENVIRONMENT_KEYS
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NM_ENVIRONMENT_KEYS],
	[m4_pushdef([NM_ENVIRONMENT_KEYS],
		m4_quote(m4_esyscmd([env | sed 's/^\([^=]\+\)=.*$/[\1],/g' | tr '\n' ' ' | sed 's/,\s*$//'])))[]NM_ENVIRONMENT_KEYS])


dnl  NM_LOAD_ENVIRONMENT
dnl  **************************************************************************
dnl
dnl  Reads all the environment variables present during the `automake` process
dnl  and defines for each of them a separate macro named `[AME_]VARNAME` (where
dnl  the `AME_` prefix stands for "AutoMake Environment")
dnl
dnl  For example,
dnl
dnl      NM_LOAD_ENVIRONMENT
dnl      AC_MSG_NOTICE([This package has been distributed by ]AME_USER[.])
dnl
dnl  prints on my computer:
dnl
dnl      This package has been distributed by madmurphy.
dnl
dnl  All `AME_*` macros contain literals and no system calls
dnl
dnl  Be aware that environment variables can contain unmatched quotes. This macro is safe in this regard and will load all environment variables no matter what. But the problem will still raise when you try to expand a corresponding `AME_*` macro containing unmatched quotes. For example, a user might have a `LESS_TERMCAP_mb` variable set to `\x1b[01;31m` -- for colouring the Unix utility `less` -- which contains the left quote `[`. And if you try to expand the `AME_LESS_TERMCAP_mb` macro:
dnl  
dnl      NM_LOAD_ENVIRONMENT
dnl      AME_LESS_TERMCAP_mb
dnl          ==> m4:test.m4:2: ERROR: end of file in string
dnl
dnl  But the variable is correctly saved in a macro, so temporarily changing quotes will be enough to solve the problem:
dnl
dnl      NM_LOAD_ENVIRONMENT
dnl      m4_changequote
dnl      AME_LESS_TERMCAP_mb
dnl      m4_changequote([, ])
dnl
dnl  This macro can be invoked only once. Note that `automake` runs at a
dnl  different time (and often even on a different computer) than the
dnl  `configure` script.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN_ONCE([NM_LOAD_ENVIRONMENT], 
	[m4_esyscmd_s([echo "m4_changequote({{<<, >>}}){{<<>>}}$(env | sed 's/^\([^=]\+\)=\(.*\)$/m4_define({{<<AME_\1>>}}, {{<<\2>>}})/g'){{<<>>}}m4_changequote([, ])"])])



dnl  **************************************************************************
dnl  NOTE:  The `NM_` prefix (which stands for "Not autoMake") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

