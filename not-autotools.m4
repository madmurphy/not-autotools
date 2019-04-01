dnl  ***************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl            A collection of useful m4ish macros for GNU Autotools
dnl
dnl                                               -- Released under GNU LGPL3 --
dnl
dnl  ***************************************************************************



dnl  ***************************************************************************
dnl  G E N E R A L   P U R P O S E   M A C R O S
dnl  ***************************************************************************



dnl  NA_UP_WORDS_ONLY(string)
dnl  ***************************************************************************
dnl
dnl  Replaces `/[a-z]/g` with `/[A-Z]/g` and `/\W/g,` with `'_'`,
dnl
dnl  ***************************************************************************
m4_define([NA_UP_WORDS_ONLY],
	[m4_translit([$1],
		[ !"#$%&\'()*+,./0123456789:;<=>?@[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~],
		[________________________________________ABCDEFGHIJKLMNOPQRSTUVWXYZ____])])


dnl  NA_GET_LIB_VERSION_ENV(libname, majver, minver, revver)
dnl  ***************************************************************************
dnl
dnl  Gets the version environment for a library project and sets the versioning
dnl  macros accordingly. This macro can be invoked only once. After being
dnl  invoked the following argumentless macros will be created:
dnl
dnl  - `NA_MULTIVERSION_LIB`: expands to `1` if the `$MULTIVERSION_LIB`
dnl    environment variable was set to any non-empty value other than `no`
dnl    during the the automake process, expands to `0` otherwise
dnl  - `NA_LIBRARY_NAME`: expands to the argument `libname` passed to this macro
dnl  - `NA_LIBRARY_MAJVER`: expands to the argument `majver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_MINVER`: expands to the argument `minver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_REVVER`: expands to the argument `revver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_LOCALNAME` expands to `libname[]majver` when
dnl    `NA_MULTIVERSION_LIB` expands to [yes], it expands to `libname` otherwise
dnl
dnl  ***************************************************************************
AC_DEFUN_ONCE([NA_GET_LIB_VERSION_ENV], [
	m4_define([NA_LIBRARY_NAME], [$1])
	m4_define([NA_LIBRARY_MAJVER], [$2])
	m4_define([NA_LIBRARY_MINVER], [$3])
	m4_define([NA_LIBRARY_REVVER], [$4])
	m4_define([NA_MULTIVERSION_LIB], m4_esyscmd_s([test "x${MULTIVERSION_LIB}" = x -o "x${MULTIVERSION_LIB}" = xno && echo 'no' || echo 'yes']))
	m4_define([NA_LIBRARY_LOCALNAME], m4_if(NA_MULTIVERSION_LIB, [yes], NA_LIBRARY_NAME[]NA_LIBRARY_MAJVER, NA_LIBRARY_NAME))
])


dnl  NA_SET_GLOBALLY(name, value)
dnl
dnl  ***************************************************************************
dnl
dnl  Creates a new argumentless macro named `[NA_]name` and a new output
dnl  substitution named `name`, both expanding to `value` when invoked. This
dnl  macro can be invoked only after having invoked `AC_INIT()`
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_SET_GLOBALLY], [
	m4_define([NA_$1], [$2])
	AC_SUBST([$1], ["$2"])
])


dnl  NA_GET_PROGS(prog1, [, prog2, [prog3[, ... progN ]]])
dnl  ***************************************************************************
dnl
dnl  Checks whether one or more programs can be retrieved automatically. For
dnl  each program `progx` an uppercase bash variable named `PROGX` containing
dnl  the path where `progx` is located will be created. If a program is not
dnl  reachable an error will be generated.
dnl
dnl  Requires: `NA_UP_WORDS_ONLY()`
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
dnl  be retrieved automatically. For each program `progx` an uppercase bash
dnl  variable named `PROGX` containing the path where `progx` is located will be
dnl  created. If a program is not reachable and the user has not provided any
dnl  path for it an error will be generated. The program names given to this
dnl  function will be advertised among the `influential environment variables`
dnl  visible when launching `./configure --help`.
dnl
dnl  Requires: `NA_UP_WORDS_ONLY()`
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
dnl  Note:  The `NA_` prefix (which stands for "Not Autotools") is used
dnl         with the purpose of avoiding collisions with the default Autotools
dnl `       prefixes `AC_`, AM_`, `AS_`, `AX_`, `LT_`.
dnl  ***************************************************************************


dnl  EOF


