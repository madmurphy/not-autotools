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
dnl                                                -- Released under GNU GPL3 --
dnl
dnl                                   https://github.com/madmurphy/not-autotools
dnl  ***************************************************************************



dnl  ***************************************************************************
dnl  G E N E R A L   P U R P O S E   M A C R O S
dnl  ***************************************************************************



dnl  NA_UP_WORDS_ONLY(string)
dnl  ***************************************************************************
dnl
dnl  Replaces `/[a-z]/g` with `/[A-Z]/g` and `/\W/g,` with `'_'`
dnl
dnl  Useful for sanitizing strings that need to be used as shell variable names.
dnl
dnl  For example,
dnl
dnl      AC_MSG_NOTICE([NA_UP_WORDS_ONLY([an.invalid-variable_name])])
dnl
dnl  will print `AN_INVALID_VARIABLE_NAME`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  ***************************************************************************
m4_define([NA_UP_WORDS_ONLY],
	[m4_translit([$1],
		[ !"#$%&\'()*+,-./0123456789:;<=>?@[\\]^`abcdefghijklmnopqrstuvwxyz{|}~],
		[________________________________________ABCDEFGHIJKLMNOPQRSTUVWXYZ____])])


dnl  NA_SET_GLOBALLY(name, value)
dnl  ***************************************************************************
dnl
dnl  Creates a new argumentless macro named `[CM_]name` (where the `CM_` prefix
dnl  stands for "Custom Macro") and a new output substitution named `name`, both
dnl  expanding to `value` when invoked
dnl
dnl  For example:
dnl
dnl      NA_SET_GLOBALLY([PACKAGE_DESCRIPTION], [Some description])
dnl      AC_MSG_NOTICE([Package description: ]CM_PACKAGE_DESCRIPTION)
dnl      AC_MSG_NOTICE([Package description: ${PACKAGE_DESCRIPTION}])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Author: madmurphy
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_SET_GLOBALLY], [
	m4_define([CM_$1], [$2])
	AC_SUBST([$1], ['$2'])
])


dnl  NA_GET_PROGS(prog1[, prog2, [prog3[, ... progN ]]])
dnl  ***************************************************************************
dnl
dnl  Checks whether one or more programs can be retrieved automatically
dnl
dnl. For each program `progx` an uppercase shell variable named `PROGX`
dnl  containing the path where `progx` is located will be created. If a program
dnl  is not reachable an error will be generated.
dnl
dnl  For example:
dnl
dnl      NA_GET_PROGS([find], [xargs], [customprogram], [etcetera])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_UP_WORDS_ONLY()`
dnl  Author: madmurphy
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_GET_PROGS], [
	m4_if([$#], [0], [], [
		AC_PATH_PROG(NA_UP_WORDS_ONLY([$1]), [$1])
		AS_IF([test "x@S|@{]NA_UP_WORDS_ONLY([$1])[}" = x], [AC_MSG_ERROR([$1 utility not found])])
		m4_if(m4_eval([$# > 1]), [1], [NA_GET_PROGS(m4_shift($*))])
	])
])


dnl  NA_REQ_PROGS(prog1, descr1[, prog2, descr2[, ... progN, ... descrN]]])
dnl  ***************************************************************************
dnl
dnl  Checks whether one or more programs have been provided by the user or can
dnl  be retrieved automatically
dnl
dnl  For each program `progx` an uppercase shell variable named `PROGX`
dnl  containing the path where `progx` is located will be created. If a program
dnl  is not reachable and the user has not provided any path for it an error
dnl  will be generated. The program names given to this macro will be advertised
dnl  among the `influential environment variables` visible when launching
dnl  `./configure --help`.
dnl
dnl  For example:
dnl
dnl      NA_REQ_PROGS(
dnl          [find],             [Unix find utility],
dnl          [xargs],            [Unix xargs utility],
dnl          [customprogram],    [Some custom program],
dnl          [etcetera],         [Et cetera]
dnl      )
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_UP_WORDS_ONLY()`
dnl  Author: madmurphy
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_REQ_PROGS], [
	m4_if([$#], [0], [], [
		AC_ARG_VAR(NA_UP_WORDS_ONLY([$1]), [$2])
		AS_IF([test "x@S|@{]NA_UP_WORDS_ONLY([$1])[}" = x], [
			AC_PATH_PROG(NA_UP_WORDS_ONLY([$1]), [$1])
			AS_IF([test "x@S|@{]NA_UP_WORDS_ONLY([$1])[}" = x], [AC_MSG_ERROR([$1 utility not found])])
		])
		m4_if(m4_eval([$# + 1 >> 1]), [1], [], [NA_REQ_PROGS(m4_shift2($*))])
	])
])



dnl  ***************************************************************************
dnl  Note:  The `NA_` prefix (which stands for "Not Autotools") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  ***************************************************************************


dnl  EOF

