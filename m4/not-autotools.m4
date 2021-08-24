dnl  **************************************************************************
dnl         _   _       _      ___        _        _              _     
dnl        | \ | |     | |    / _ \      | |      | |            | |    
dnl        |  \| | ___ | |_  / /_\ \_   _| |_ ___ | |_ ___   ___ | |___ 
dnl        | . ` |/ _ \| __| |  _  | | | | __/ _ \| __/ _ \ / _ \| / __|
dnl        | |\  | (_) | |_  | | | | |_| | || (_) | || (_) | (_) | \__ \
dnl        \_| \_/\___/ \__| \_| |_/\__,_|\__\___/ \__\___/ \___/|_|___/
dnl
dnl              A collection of useful m4 macros for GNU Autotools
dnl
dnl                                               -- Released under GNU GPL3 --
dnl
dnl                                  https://github.com/madmurphy/not-autotools
dnl  **************************************************************************



dnl  **************************************************************************
dnl  G E N E R A L   P U R P O S E   M A C R O S
dnl  **************************************************************************



dnl  NA_SANITIZE_VARNAME(string)
dnl  **************************************************************************
dnl
dnl  Replaces `/\W/g,` with `'_'` and `/^\d/` with `_\0`
dnl
dnl  Useful for sanitizing strings that need to be used as variable names in
dnl  several programming languages (Bash, C, JavaScript, etc.).
dnl
dnl  For example,
dnl
dnl      AC_MSG_NOTICE([NA_SANITIZE_VARNAME([an.invalid-variable_name])])
dnl
dnl  will print `an_invalid_variable_name`.
dnl
dnl  If `string` begins with a number, an underscore will be prepended to the
dnl  latter (e.g.: `NA_SANITIZE_VARNAME([0123FOO])` => `_0123FOO`).
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_SANITIZE_VARNAME],
	[m4_if(m4_bregexp(m4_normalize([$1]), [[0-9]]), [0], [_])[]m4_translit(m4_normalize([$1]),
		[ !"#$%&\'()*+,-./:;<=>?@[\\]^`{|}~],
		[__________________________________])])


dnl  NA_ESC_APOS(string)
dnl  **************************************************************************
dnl
dnl  Escapes all the occurrences of the apostrophe character in `string`
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_ESC_APOS],
	[m4_bpatsubst([$@], ['], ['\\''])])


dnl  NA_DOUBLE_DOLLAR(string)
dnl  **************************************************************************
dnl
dnl  Replaces all the occurrences of the dollar character in `string` with two
dnl  dollar characters (Makefile escaping)
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_DOUBLE_DOLLAR],
	[m4_bpatsubst([$@], [\$\|@S|@], [@S|@@S|@])])


dnl  NA_TRIANGLE_BRACKETS_TO_MAKE_VARS(string)
dnl  **************************************************************************
dnl
dnl  Replaces all variables enclosed within triangle brackets with Makefile
dnl  syntax for variables
dnl
dnl  For example,
dnl
dnl      NA_TRIANGLE_BRACKETS_TO_MAKE_VARS([cp 'some_file' '<docdir>/<PACKAGE_TARNAME>'])
dnl
dnl  expands to
dnl
dnl      cp 'some_file' '$(docdir)/$(PACKAGE_TARNAME)'
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_TRIANGLE_BRACKETS_TO_MAKE_VARS],
	[m4_bpatsubst([$*], [<\([A-Za-z0-9_@*%<?^+|]+\)>],
		[m4_if(m4_len([\1]), [1],
			[@S|@\1],
			[@S|@@{:@\1@:}@])])])


dnl  NA_TRIANGLE_BRACKETS_TO_SHELL_VARS(string)
dnl  **************************************************************************
dnl
dnl  Replaces all variables enclosed within triangle brackets with shell syntax
dnl  for variables
dnl
dnl  For example,
dnl
dnl      NA_TRIANGLE_BRACKETS_TO_SHELL_VARS([cp 'some_file' "<docdir>/<PACKAGE_TARNAME>"])
dnl
dnl  expands to
dnl
dnl      cp 'some_file' "${docdir}/${PACKAGE_TARNAME}"
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_TRIANGLE_BRACKETS_TO_SHELL_VARS],
	[m4_bpatsubst([$*], [<\([A-Za-z0-9_:#*%@$|{}]*\)>], [@S|@{\1}])])


dnl  NA_AMENDMENTS_SED_EXPR([amendment1[, amendment2[, ... amendmentN]]])
dnl  **************************************************************************
dnl
dnl  Creates a `sed` expression using all the "exception[-replacement_file]"
dnl  pairs passed as arguments ("amendments")
dnl
dnl  This macro is mostly meant to be used internally by `NA_AMEND()` (although
dnl  it can be invoked directly). It works like `NA_AMEND()`, except that only
dnl  creates a valid `sed` expression without actually ever invoking `sed`
dnl  (hence no `output-file` or `amendable-file` parameters are used here). For
dnl  more information, please refer to the documentation of `NA_AMEND()`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_AMENDMENTS_SED_EXPR],
	[m4_ifblank([$1],
		['/!\s*START_EXCEPTION\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*END_EXCEPTION\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*ENTRY_POINT\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*START_OMISSION\s*!/,/!\s*END_OMISSION\s*!/{d}'],
		['m4_ifnblank(m4_normalize(m4_argn([2], $1)), [/!\s*END_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{r '"m4_normalize(m4_argn([2], $1))"$'\n};/!\s*ENTRY_POINT\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{r '"m4_normalize(m4_argn([2], $1))"@S|@'\n};])/!\s*START_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/,/!\s*END_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{d};/!\s*START_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{d};'NA_AMENDMENTS_SED_EXPR(m4_shift($@))])])


dnl  NA_AMEND(output-file, amendable-file[, amendment1[, ... amendmentN]])
dnl  **************************************************************************
dnl
dnl  Creates a new file amending a model with the content of one or more files
dnl
dnl  This macro requires a `output-file` parameter and a `amendable-file`
dnl  parameter followed by a variadic list of amendments containing information
dnl  about the amendable sections in `amendable-file`.
dnl
dnl  Each amendment is a list composed of one or two members (further members
dnl  will be ignored), where the first member contains the name of the section
dnl  to replace, and the second member, if present, the path of the file that
dnl  provides a replacement. If the second member is absent or empty the
dnl  exception referred to by the first member is simply erased. For example,
dnl  the following code,
dnl
dnl      NA_AMEND([src/main.c], [models/main.c],
dnl          [[OFF_T_TYPE],      []],
dnl          [[I_O_FUNCTIONS],   [posix-io.c]]],
dnl          [[LARGE_FILES],     [large-files.c]])
dnl
dnl  creates a new file `src/main.c` using `models/main.c` as model, after
dnl  erasing the replaceable section named `OFF_T_TYPE` and replacing the
dnl  sections named `I_O_FUNCTIONS` and `LARGE_FILES` with the content of
dnl  `posix-io.c` and `large-files.c`.
dnl
dnl  Replaceable sections in the model can be either **exceptions** or
dnl  **entry points**.
dnl
dnl  **Exceptions** are blocks of text enclosed between an opening line
dnl  containing the tag `!START_EXCEPTION(amendment-name)!` and a closing line
dnl  containing the tag `!END_EXCEPTION(amendment-name)!`.
dnl
dnl  For example:
dnl
dnl      /*@@@@@@@@@@@@@@@@ !START_EXCEPTION(I_O_FUNCTIONS)! @@@@@@@@@@@@@@@@*/
dnl
dnl      This is the content of the exception `I_O_FUNCTIONS`...
dnl
dnl      /*@@@@@@@@@@@@@@@@@ !END_EXCEPTION(I_O_FUNCTIONS)! @@@@@@@@@@@@@@@@@*/
dnl
dnl  If no amendment for a particular exception is passed to `NA_AMEND()`
dnl  the original content of the exception block is kept untouched, except for
dnl  the tags that surround it, which will be removed.
dnl
dnl  All opening and closing lines are always erased entirely (even when they
dnl  contain further text -- as the `/*@...` and `...@*/` characters in the
dnl  example above).
dnl
dnl  **Entry points** instead are single lines containing the tag
dnl  `!ENTRY_POINT([amendment-name])!`, and are used as placeholders for
dnl  optional amendments that do not replace existing text:
dnl
dnl      /*@@@@@@@@@@@@@@@@@@ !ENTRY_POINT(I_O_FUNCTIONS)! @@@@@@@@@@@@@@@@@@*/
dnl
dnl  Furthermore, this macro provides also a way to store meta-information or
dnl  comments in the model, as the blocks of text enclosed between the tags
dnl  `!START_OMISSION!` and `!END_OMISSION!` are always removed:
dnl
dnl      /*@@@@@@@@@@@@@@@@@@@@@@@@ !START_OMISSION! @@@@@@@@@@@@@@@@@@@@@@@@*/
dnl
dnl      This text will be lost.
dnl
dnl      /*@@@@@@@@@@@@@@@@@@@@@@@@@ !END_OMISSION! @@@@@@@@@@@@@@@@@@@@@@@@@*/
dnl
dnl  Because this macro is based on a `sed` expression, amendment names can
dnl  contain alphanumeric characters only.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_AMENDMENTS_SED_EXPR()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_AMEND],
	[{ echo 'Creating $1...'; sed NA_AMENDMENTS_SED_EXPR(m4_shift2($@)) "$2" > "$1"; }])


dnl  NC_REQUIRE(macro1[, macro2[, macro3[, ... macroN]]])
dnl  **************************************************************************
dnl
dnl  Variadic version of `AC_REQUIRE()` that can be invoked also from the
dnl  global scope
dnl
dnl  For example:
dnl
dnl      NC_REQUIRE([AC_PROG_LN_S], [AC_PROG_SED])
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_REQUIRE],
	[m4_if([$#], [0],
		[m4_warn([syntax],
			[macro NC_REQUIRE() has been called without arguments])],
		[m4_ifblank([$1],
			[m4_warn([syntax],
				[ignoring empty argument in NC_REQUIRE()])],
			[AC_REQUIRE(m4_normalize([$1]))])[]m4_if([$#], [1], [],
			[m4_newline()NC_REQUIRE(m4_shift($@))])])])



dnl  NC_ARG_MISSING(argument)
dnl  **************************************************************************
dnl
dnl  Checks whether `argument` or `argument=*` has **not** been passed to the
dnl  `configure` script, and triggers `true` or `false` accordingly
dnl
dnl  Sometimes it might be relatively hard to know whether a particular
dnl  variable has been set by the user or not, since the `configure` script
dnl  will assign some default value to it even if the user has not expressed
dnl  any wish via command line (think of the `${docdir}` variable for example,
dnl  set either to the value of the `--docdir=...` argument specified by the
dnl  user or to the `'${datarootdir}/doc/${PACKAGE_TARNAME}'` default string).
dnl
dnl  It is always possible to compare the current value with the default value
dnl  normally assigned by the `configure` script... but what if the latter
dnl  changes with new releases of GNU Autoconf?
dnl
dnl  To solve the problem this macro looks directly to the actual arguments
dnl  passed by the user.
dnl
dnl  For example:
dnl
dnl      AS_IF([NC_ARG_MISSING([--docdir])],
dnl          [AC_MSG_NOTICE([Option `--docdir` has not been specified])],
dnl          [AC_MSG_NOTICE([Option `--docdir` has been specified])])
dnl
dnl  In order to know the opposite condition (i.e. whether a particular
dnl  argument *has* been passed to the `configure` script) it is possible to
dnl  use the `!` shell operator. For example:
dnl
dnl      AS_IF([! NC_ARG_MISSING([--docdir])],
dnl          [AC_MSG_NOTICE([Option `--docdir` has been specified])],
dnl          [AC_MSG_NOTICE([Option `--docdir` has not been specified])])
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_ARG_MISSING],
	[{ case " @S|@{@} " in *" _AS_QUOTE([$1]) "*|*" _AS_QUOTE([$1])="*) false; ;; esac; }])


dnl  NC_ARG_MISSING_WITHVAL(argument)
dnl  **************************************************************************
dnl
dnl  Checks whether `argument=*` has **not** been passed to the `configure`
dnl  script, and triggers `true` or `false` accordingly
dnl
dnl  Like `NC_ARG_MISSING()` but this macro considers missing also any argument
dnl  that is present but does not have an equals sign (and possibly a value)
dnl  following it. Neither the equals sign or the value must be passed to the
dnl  macro. For example, to know whether `--docdir=*` has been passed to the
dnl  `configure` script, use `NC_ARG_MISSING_WITHVAL([--docdir])`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_ARG_MISSING_WITHVAL],
	[{ case " @S|@{@} " in *" _AS_QUOTE([$1])="*) false; ;; esac; }])


dnl  NC_SUBST_NOTMAKE(var[, value])
dnl  **************************************************************************
dnl
dnl  Calls `AC_SUBST(var[, value])` immediately followed by
dnl  `AM_SUBST_NOTMAKE(var)`
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_SUBST_NOTMAKE], [
	AC_SUBST([$1][]m4_if([$#], [0], [], [$#], [1], [], [, [$2]]))
	AM_SUBST_NOTMAKE([$1])
])


dnl  NC_GLOBAL_LITERALS(name1, [val1][, name2, [val2][, ... nameN, [valN]]])
dnl  **************************************************************************
dnl
dnl  For each `nameN`-`valN` pair, creates a new argumentless macro named
dnl  `[GL_]nameN` (where the `GL_` prefix stands for "Global Literal") and a
dnl  new output substitution named `nameN`, both expanding to `valN` when
dnl  invoked
dnl
dnl  For example:
dnl
dnl      NC_GLOBAL_LITERALS(
dnl          [PROJECT_DESCRIPTION],  [Some description],
dnl          [COPYLEFT],             [madmurphy]
dnl      )
dnl      AC_MSG_NOTICE([package copyleft: ]GL_COPYLEFT)
dnl      AC_MSG_NOTICE([package copyleft: ${COPYLEFT}])
dnl
dnl  Each argument can safely contain any arbitrary character, however all the
dnl  `nameN` arguments will be processed by `NA_SANITIZE_VARNAME()`, and all
dnl  the `valN` arguments will be processed by `m4_normalize()`.
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()` and `NA_ESC_APOS()`
dnl  Version: 1.0.1
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_GLOBAL_LITERALS],
	[m4_pushdef([_lit_], m4_quote(NA_SANITIZE_VARNAME([$1])))[]m4_define([GL_]_lit_,
		m4_normalize([$2]))
	AC_SUBST(_lit_, ['NA_ESC_APOS(m4_normalize([$2]))'])[]m4_popdef([_lit_])[]m4_if(m4_eval([$# > 2]), [1],
		[NC_GLOBAL_LITERALS(m4_shift2($@))])])


dnl  NC_GLOBAL_LITERALS_NOTMAKE(name1, [val1][, ... nameN, [valN]]])
dnl  **************************************************************************
dnl
dnl  Exactly like `NC_GLOBAL_LITERALS`, but does not create `Makefile`
dnl  variables
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()` and `NA_ESC_APOS()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_GLOBAL_LITERALS_NOTMAKE],
	[m4_pushdef([_lit_], m4_quote(NA_SANITIZE_VARNAME([$1])))[]m4_define([GL_]_lit_,
		m4_normalize([$2]))
	AC_SUBST(_lit_, ['NA_ESC_APOS(m4_normalize([$2]))'])
	AM_SUBST_NOTMAKE(_lit_)[]m4_popdef([_lit_])[]m4_if(m4_eval([$# > 2]), [1],
		[NC_GLOBAL_LITERALS_NOTMAKE(m4_shift2($@))])])


dnl  NC_GET_PROGS(prog1[, prog2, [prog3[, ... progN ]]])
dnl  **************************************************************************
dnl
dnl  Checks whether one or more programs can be retrieved automatically
dnl
dnl. For each program `progx` an uppercase shell variable named `PROGX`
dnl  containing the path where `progx` is located will be created.
dnl
dnl  For example:
dnl
dnl      NC_GET_PROGS([find], [xargs], [customprogram], [etcetera])
dnl
dnl  Non-alphanumeric characters in the program name will be replaced with an
dnl  underscore in the upper-case shell variable. For example, searching for
dnl  the program `xdg-mime` will set a shell variable named `XDG_MIME`.
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_GET_PROGS],
	[m4_ifnblank([$1],
		[m4_newline()AC_PATH_PROG(m4_toupper(NA_SANITIZE_VARNAME([$1])), [$1])[]NC_GET_PROGS(m4_shift($@))])])


dnl  NC_REQ_PROGS(prog1[, descr1][, prog2[, descr2][, ... progN[, descrN]]])
dnl  **************************************************************************
dnl
dnl  Checks whether one or more programs have been provided by the user or can
dnl  be retrieved automatically, generating an error if both conditions are
dnl  absent
dnl
dnl  For each program `progx` an uppercase shell variable named `PROGX`
dnl  containing the path where `progx` is located will be created. If a program
dnl  is not reachable and the user has not provided any path for it an error
dnl  will be generated. The program names given to this macro will be
dnl  advertised among the `influential environment variables` visible when
dnl  launching `./configure --help`.
dnl
dnl  For example:
dnl
dnl      NC_REQ_PROGS(
dnl          [find],             [Unix find utility],
dnl          [xargs],            [Unix xargs utility],
dnl          [customprogram],    [Some custom program],
dnl          [etcetera],         [Et cetera]
dnl      )
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()`
dnl  Version: 1.0.1
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_REQ_PROGS],
	[m4_ifnblank([$1],
		[m4_pushdef([_lit_], m4_quote(m4_toupper(NA_SANITIZE_VARNAME([$1]))))
		AC_ARG_VAR(_lit_,
			m4_default_quoted(m4_normalize([$2]), [$1 utility]))
		AS_IF([test "x@S|@{]_lit_[}" = x], [
			AC_PATH_PROG(_lit_, [$1])
			AS_IF([test "x@S|@{]_lit_[}" = x],
				[AC_MSG_ERROR([$1 utility not found])])[]m4_popdef([_lit_])
		])[]NC_REQ_PROGS(m4_shift2($@))])])


dnl  NM_QUERY_PROGS(prog1[, descr1][, prog2[, descr2][, ... progN[, descrN]]])
dnl  **************************************************************************
dnl
dnl  Checks whether one or more programs have been provided by the user or can
dnl  be retrieved automatically, generating an `HAVE_*` conditional for each
dnl  program
dnl
dnl  This macro is identical to `NC_REQ_PROGS()`, but instead of generating an
dnl  error if a program is not found it simply creates Automake conditionals
dnl  for each program given, each named `HAVE_[PROGN]` (where `[PROGN]` stands
dnl  for the name of each program in uppercase).
dnl
dnl  For example:
dnl
dnl      NM_QUERY_PROGS(
dnl          [find],             [Unix find utility],
dnl          [xargs],            [Unix xargs utility],
dnl          [customprogram],    [Some custom program],
dnl          [etcetera],         [Et cetera]
dnl      )
dnl
dnl      AM_COND_IF([HAVE_CUSTOMPROGRAM],
dnl          [AC_MSG_NOTICE([Some custom program found or given by the user])],
dnl          [AC_MSG_NOTICE([Some custom program not found])])
dnl
dnl  This macro can be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NM_QUERY_PROGS],
	[m4_ifnblank([$1],
		[m4_pushdef([_lit_], m4_quote(m4_toupper(NA_SANITIZE_VARNAME([$1]))))
		AC_ARG_VAR(_lit_,
			m4_default_quoted(m4_normalize([$2]), [$1 utility]))
		AS_IF([test "x@S|@{]_lit_[}" = x], [AC_PATH_PROG(_lit_, [$1])])
		AM_CONDITIONAL([HAVE_]_lit_,
			[test "x@S|@{]_lit_[}" != x])[]NM_QUERY_PROGS(m4_shift2($@))])])


dnl  NA_HELP_STRINGS(list1, help1[, list2, help2[, ... listN, helpN]])
dnl  **************************************************************************
dnl
dnl  Similar to `AS_HELP_STRING()`, but with support for multiple strings, each
dnl  one associated with one or more options
dnl
dnl  For example,
dnl
dnl      AC_ARG_ENABLE([foo],
dnl          [NA_HELP_STRINGS(
dnl              [--disable-foo],
dnl                  [disable the `foo` feature; on some machines the package might not
dnl                  work properly without the `foo` feature enabled],
dnl              [[--enable-foo], [--enable-foo=yes], [--enable-foo=enhanced]],
dnl                  [install this package with the `foo` feature enabled; if `foo` is
dnl                  enabled in `enhanced` mode Autoconf might get sentimental],
dnl              [[--enable-foo=auto], [--enable-foo=check], [@<:@omitted@:>@]],
dnl                  [decide automatically whether it is opportune to enable the `foo`
dnl                  feature on this machine or not]
dnl          )],
dnl          [:],
dnl          [AS_VAR_SET([enable_foo], ['check'])])
dnl
dnl  will print, when the user launches `./configure --help`:
dnl
dnl        --disable-foo           disable the `foo` feature; on some machines the
dnl                                package might not work properly without the `foo`
dnl                                feature enabled
dnl        --enable-foo,
dnl        --enable-foo=yes,
dnl        --enable-foo=enhanced   install this package with the `foo` feature enabled;
dnl                                if `foo` is enabled in `enhanced` mode Autoconf
dnl                                might get sentimental
dnl        --enable-foo=auto,
dnl        --enable-foo=check,
dnl        [omitted]               decide automatically whether it is opportune to
dnl                                enable the `foo` feature on this machine or not
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NA_HELP_STRINGS],
	[m4_if(m4_count($1), [1],
		[m4_if([$#], [0], [], [$#], [1],
			[m4_text_wrap($1, [  ])],
			[AS_HELP_STRING(m4_normalize($1), [$2])m4_if([$#], [2], [], [m4_newline()NA_HELP_STRINGS(m4_shift2($@))])])],
		[m4_text_wrap(m4_car($1)[,], [  ])m4_newline()NA_HELP_STRINGS(m4_dquote(m4_shift($1))m4_if([$#], [1], [], [, m4_shift($@)]))])])


dnl  NC_MAKETARGET_SUBST(target[, [[prerequisites, ]order-only-pr, ]recipe])
dnl  **************************************************************************
dnl
dnl  Creates a `make` substitution containing a target declaration
dnl
dnl  The `target` argument is used for a `configure` substitution named
dnl  `[na_target_]target`, to be placed as the only content of a single line in
dnl  the `Makefile.am` file. Each line of the `recipe` argument will be
dnl  indented of one TAB.
dnl
dnl  For example, after placing the following content in `configure.ac`,
dnl
dnl      NC_MAKETARGET_SUBST([echo-test], ['clean all'],
dnl          ['echo '\''Hello world'\'' && date;'])
dnl
dnl  and the following line in `Makefile.am`,
dnl
dnl      @na_target_echo_test@
dnl
dnl  the latter will be substituted with the following `Makefile` recipe:
dnl
dnl      echo-test: clean all
dnl              echo 'Hello world' && date;
dnl
dnl  Exactly like the second argument of `AC_SUBST()`, all arguments here
dnl  except the first one support shell expansion and must be properly quoted.
dnl
dnl  Example #1: Target name and recipe
dnl
dnl  configure.ac:
dnl
dnl      NC_MAKETARGET_SUBST([echo-test], ['echo foobar'])
dnl
dnl  Makefile.am:
dnl
dnl      @na_target_echo_test@
dnl
dnl  Result in Makefile:
dnl
dnl      echo-test:
dnl              echo foobar
dnl
dnl  Example #2: Target name, prerequisites and recipe
dnl
dnl  configure.ac:
dnl
dnl      NC_MAKETARGET_SUBST([echo-test], ['foo'], ['echo foobar'])
dnl
dnl  Makefile.am:
dnl
dnl      @na_target_echo_test@
dnl
dnl  Result in Makefile:
dnl
dnl      echo-test: foo
dnl              echo foobar
dnl
dnl  Example #3: Target name, prerequisites, order-only prerequisites and
dnl  recipe
dnl
dnl  configure.ac:
dnl
dnl      NC_MAKETARGET_SUBST([echo-test], ['foo'], ['bar'], ['echo foobar'])
dnl
dnl  Makefile.am:
dnl
dnl      @na_target_echo_test@
dnl
dnl  Result in Makefile:
dnl
dnl      echo-test: foo | bar
dnl              echo foobar
dnl
dnl  Example #4: Target name, order-only prerequisites and recipe
dnl
dnl  configure.ac:
dnl
dnl      NC_MAKETARGET_SUBST([echo-test], [], ['bar'], ['echo foobar'])
dnl
dnl  Makefile.am:
dnl
dnl      @na_target_echo_test@
dnl
dnl  Result in Makefile:
dnl
dnl      echo-test: | bar
dnl              echo foobar
dnl
dnl  Example #5: Target name only
dnl
dnl  This is a special case. As no `recipe` is provided, a Make variable is
dnl  used for the recipe's content. The Make variable is a newly created
dnl  substitution named exactly like the target – but please notice the
dnl  different way in which hyphens are treated in the two names. The content
dnl  of this substitution is left to you, so you will have to make sure
dnl  yourself that it is a suitable content for a recipe.
dnl
dnl  configure.ac:
dnl
dnl      AS_VAR_SET([echo_test], ['echo foobar'])
dnl      NC_MAKETARGET_SUBST([echo-test])
dnl
dnl  Makefile.am:
dnl
dnl      @na_target_echo_test@
dnl
dnl  Result in Makefile:
dnl
dnl      echo_test = echo foobar
dnl      ...
dnl      echo-test:
dnl              $(echo_test)
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()`
dnl  Version: 1.0.1
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_MAKETARGET_SUBST], [
	m4_pushdef([__tgtname__],
		m4_quote(NA_SANITIZE_VARNAME([$1])))
	AC_REQUIRE([AC_PROG_SED])
	m4_if([$#], [0], [], [$#], [1], [
		AC_SUBST(__tgtname__)
		AC_SUBST([na_target_]__tgtname__, ['$1:'@S|@'\n\t''@S|@@{:@__tgtname__@:}@'])
	], [
		AS_VAR_SET([_na_recipe_], m4_argn([$#], $@))
		AC_SUBST([na_target_]__tgtname__,
		['$1:m4_if([$#], [2], ['@S|@'\n'], [$#], [3],
			[m4_ifblank([$2], ['], [ '$2])@S|@'\n'],
			[m4_ifblank([$3],
				[m4_ifblank([$2], ['], [ '$2])],
				[m4_ifblank([$2], [ | '$3], [ '$2' | '$3])])@S|@'\n'])"@S|@@{:@echo "${_na_recipe_}" | ${SED} s/^/\\t/g@:}@"])
		AS_UNSET([_na_recipe_])
	])
	AM_SUBST_NOTMAKE([na_target_]__tgtname__)
	m4_popdef([__tgtname__])
])



dnl  **************************************************************************
dnl  NOTE:  The `NA_` prefix (which stands for "Not Autotools") and the `NC_`
dnl         prefix (which stands for "Not autoConf") are used with the purpose
dnl         of avoiding collisions with the default Autotools prefixes `AC_`,
dnl         `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

