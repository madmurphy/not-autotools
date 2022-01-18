dnl  -*- Mode: M4; indent-tabs-mode: t; c-basic-offset: 4; tab-width: 4 -*-

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
dnl  NOTE:  This is only a selection of macros from the **Not Autotools**
dnl         project without documentation. For the entire collection and the
dnl         documentation please refer to the project's website.
dnl  **************************************************************************



dnl  NA_ESC_APOS(string)
dnl  **************************************************************************
dnl
dnl  Escapes all the occurrences of the apostrophe character in `string`
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NA_ESC_APOS],
	[m4_bpatsubst([$@], ['], ['\\''])])


dnl  NA_DOUBLE_DOLLAR(string)
dnl  **************************************************************************
dnl
dnl  Replaces all the occurrences of the dollar character in `string` with two
dnl  dollar characters (Makefile escaping)
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NA_DOUBLE_DOLLAR],
	[m4_bpatsubst([$@], [\$\|@S|@], [@S|@@S|@])])


dnl  NA_TRIANGLE_BRACKETS_TO_MAKE_VARS(string)
dnl  **************************************************************************
dnl
dnl  Replaces all variables enclosed within triangle brackets with Makefile
dnl  syntax for variables
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
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
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NA_TRIANGLE_BRACKETS_TO_SHELL_VARS],
	[m4_bpatsubst([$*], [<\([A-Za-z0-9_:#*%@$|{}]*\)>], [@S|@{\1}])])


dnl  NA_AMENDMENTS_SED_EXPR([amendment1[, amendment2[, ... amendmentN]]])
dnl  **************************************************************************
dnl
dnl  Creates a `sed` expression using all the "exception[-replacement_file]"
dnl  pairs passed as arguments ("amendments")
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NA_AMENDMENTS_SED_EXPR],
	[m4_ifblank([$1],
		['/!\s*START_EXCEPTION\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*END_EXCEPTION\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*ENTRY_POINT\s*@{:@@<:@^@:}@@:>@*@:}@\s*!/{d};/!\s*START_OMISSION\s*!/,/!\s*END_OMISSION\s*!/{d}'],
		['m4_ifnblank(m4_normalize(m4_argn([2], $1)), [/!\s*END_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{r '"m4_normalize(m4_argn([2], $1))"$'\n};/!\s*ENTRY_POINT\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{r '"m4_normalize(m4_argn([2], $1))"@S|@'\n};])/!\s*START_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/,/!\s*END_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{d};/!\s*START_EXCEPTION\s*@{:@m4_normalize(m4_argn([1], $1))@:}@\s*!/{d};'NA_AMENDMENTS_SED_EXPR(m4_shift($@))])])


dnl  NA_AMEND(output-file, amendable-file[, amendment1[, ... amendmentN]])
dnl  **************************************************************************
dnl
dnl  Creates a new file amending a model with the content of one or more files
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NA_AMEND],
	[{ echo 'Creating $1...'; sed NA_AMENDMENTS_SED_EXPR(m4_shift2($@)) "$2" > "$1"; }])


dnl  NC_SUBST_NOTMAKE(var[, value])
dnl  **************************************************************************
dnl
dnl  Calls `AC_SUBST(var[, value])` immediately followed by
dnl  `AM_SUBST_NOTMAKE(var)`
dnl
dnl  From: not-autotools/m4/not-autotools.m4
dnl
AC_DEFUN([NC_SUBST_NOTMAKE], [
	AC_SUBST([$1][]m4_if([$#], [0], [], [$#], [1], [], [, [$2]]))
	AM_SUBST_NOTMAKE([$1])
])



dnl  **************************************************************************
dnl  NOTE:  The `NA_` prefix (which stands for "Not Autotools") is used with
dnl         the purpose of avoiding collisions with the default Autotools
dnl         prefixes `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

