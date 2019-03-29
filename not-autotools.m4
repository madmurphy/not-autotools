dnl  NA_DEFINE_SUBSTRINGS_AS(string, regexp, macro0[, macro1[, ... macroN ]])
dnl  ***************************************************************************
dnl
dnl  Searches for the first match of `regexp` in `string`. For both the entire
dnl  regular expression `regexp` (`\0`) and each sub-expression within capturing
dnl  parentheses (`\1`, `\2`, `\3`, ... , `\N`) a macro expanding to the
dnl  corresponding matching text will be created, named according to the
dnl  argument `macroN` passed. If a `macroN` argument is omitted or empty, the
dnl  corresponding parentheses in the regular expression will be considered as
dnl  non-capturing. If `regexp` or some of its capturing parentheses cannot be
dnl  found in `string` the corresponding macro(s) will not be defined.
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_DEFINE_SUBSTRINGS_AS], [
	m4_if(m4_eval([$# > 2]), [1], [
		m4_if(m4_normalize(m4_argn([$#], $*)), [], [],
			[m4_bregexp([$1], [$2], [m4_define(m4_normalize(m4_argn([$#], $*)), \]m4_if([$#], [3], [&], m4_eval([$# - 3]))[)])])
		m4_if(m4_eval([$# > 3]), [1], [NA_DEFINE_SUBSTRINGS_AS(m4_reverse(m4_shift(m4_reverse($@))))])
	])
])


dnl  NA_GET_VERSION_ENVIRONMENT(libname, majver, minver, revver)
dnl  ***************************************************************************
dnl
dnl  Gets the version environment for this package and sets the versioning
dnl  macros accordingly. This macro can be invoked only once. After being
dnl  invoked the following argumentless macros will be created:
dnl
dnl  - `NA_MULTIVERSION_LIB`: expands to `[yes]` if the `$MULTIVERSION_LIB`
dnl    environment variable was set to any value other than `no` during the
dnl    the automake process, it expands to `[no]` otherwise
dnl  - `NA_LIBRARY_NAME`: expands to the argument `libname` passed to this macro
dnl  - `NA_LIBRARY_MAJVER`: expands to the argument `majver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_MINVER`: expands to the argument `minver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_REVVER`: expands to the argument `revver` passed to this
dnl    macro
dnl  - `NA_LIBRARY_LOCALNAME` expands to `libname[]majver` when
dnl    `NA_MULTIVERSION_LIB` expands to [yes], it expands to `libname` otherwise
dnl  ***************************************************************************
AC_DEFUN_ONCE([NA_GET_VERSION_ENVIRONMENT], [
	m4_define([NA_LIBRARY_NAME], [$1])
	m4_define([NA_LIBRARY_MAJVER], [$2])
	m4_define([NA_LIBRARY_MINVER], [$3])
	m4_define([NA_LIBRARY_REVVER], [$4])
	m4_define([NA_MULTIVERSION_LIB], m4_esyscmd_s([test "x${MULTIVERSION_LIB}" = x -o "x${MULTIVERSION_LIB}" = xno && echo 'no' || echo 'yes']))
	m4_define([NA_LIBRARY_LOCALNAME], m4_if(NA_MULTIVERSION_LIB, [yes], NA_LIBRARY_NAME[]NA_LIBRARY_MAJVER, NA_LIBRARY_NAME))
])


dnl  ***************************************************************************
dnl  NA_SET_GLOBALLY(name, value)
dnl
dnl  Creates a new argumentless macro named `[NA_]name` and a new output
dnl  substitution named `name`, both expanding to `value` when invoked. This
dnl  macro can be invoked only after having invoked `AC_INIT()`
dnl  ***************************************************************************
AC_DEFUN([NA_SET_GLOBALLY], [
	m4_define([NA_$1], [$2])
	AC_SUBST([$1], ["$2"])
])


dnl  ***************************************************************************
dnl  NA_REQ_PROGS(prog1, [descr1][, prog2, [descr2][, etc., [...]]])
dnl
dnl  Checks whether one or more programs have been provided by the user or can
dnl  be retrieved automatically. For each program `progx` an uppercase variable
dnl  named `PROGX` containing the path where `progx` is located will be created.
dnl  If a program is not reachable and the user has not provided any path for it
dnl  an error will be generated. The program names given to this function will
dnl  be advertised among the `influential environment variables` visible when
dnl  launching `./configure --help`.
dnl  ***************************************************************************
AC_DEFUN([NA_REQ_PROGS], [
	m4_if([$#], [0], [], [
		AC_ARG_VAR(m4_translit([$1], [a-z], [A-Z]), [$2])
		AS_IF([test "x@S|@{]m4_translit([$1], [a-z], [A-Z])[}" = x], [
			AC_PATH_PROG(m4_translit([$1], [a-z], [A-Z]), [$1])
			AS_IF([test "x@S|@{]m4_translit([$1], [a-z], [A-Z])[}" = x], [
				AC_MSG_ERROR([$1 utility not found])
			])
		])
		m4_if(m4_eval([$# + 1 >> 1]), [1], [], [NA_REQ_PROGS(m4_shift2($*))])
	])
])

