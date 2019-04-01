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
dnl  P U R E   M 4   M A C R O S
dnl  ***************************************************************************



dnl  NA_DEFINE_SUBSTRINGS_AS(string, regexp, macro0[, macro1[, ... macroN ]])
dnl  ***************************************************************************
dnl
dnl  Searches for the first match of `regexp` in `string` and defines custom
dnl  macros accordingly
dnl
dnl  For both the entire regular expression `regexp` (`\0`) and each
dnl  sub-expression within capturing parentheses (`\1`, `\2`, `\3`, ... , `\N`)
dnl  a macro expanding to the corresponding matching text will be created, named
dnl  according to the argument `macroN` passed. If a `macroN` argument is
dnl  omitted or empty, the corresponding parentheses in the regular expression
dnl  will be considered as non-capturing. If `regexp` cannot be found in
dnl  `string` no macro will be defined. If `regexp` can be found but some of its
dnl  capturing parentheses cannot, the macro(s) corresponding to the latter will
dnl  be defined as empty strings.
dnl
dnl  Example -- Get the current version string from a file named `VERSION`:
dnl
dnl      NA_DEFINE_SUBSTRINGS_AS(
dnl      
dnl          m4_include([VERSION]),
dnl      
dnl          [\([0-9]+\)\s*\.\s*\([0-9]+\)\s*\.\s*\([0-9]+\)],
dnl      
dnl          [VERSION_STR], [VERSION_MAJ], [VERSION_MIN], [VERSION_REV]
dnl      
dnl      )
dnl      
dnl      AC_INIT([foo], VERSION_MAJ[.]VERSION_MIN[.]VERSION_REV)
dnl
dnl  ***************************************************************************
AC_DEFUN([NA_DEFINE_SUBSTRINGS_AS], [
	m4_if(m4_eval([$# > 2]), [1], [
		m4_if(m4_normalize(m4_argn([$#], $*)), [], [],
			[m4_bregexp([$1], [$2], [m4_define(m4_normalize(m4_argn([$#], $*)), \]m4_if([$#], [3], [&], m4_eval([$# - 3]))[)])])
		m4_if(m4_eval([$# > 3]), [1], [NA_DEFINE_SUBSTRINGS_AS(m4_reverse(m4_shift(m4_reverse($@))))])
	])
])


dnl  NA_REPEAT_TEXT(text, n_times)
dnl  ***************************************************************************
dnl
dnl  Repeats `text` `n_times`
dnl
dnl  Every occurrence of `$#` within `text` will be replaced with the current
dnl  index. For example,
dnl
dnl      NA_REPEAT_TEXT([foo $#...], [4])
dnl
dnl  will expand to:
dnl
dnl      foo 1...foo 2...foo 3...foo 4...
dnl
dnl  ***************************************************************************
m4_define([NA_REPEAT_TEXT], [m4_if(m4_eval([$2] > 0), [1], [NA_REPEAT_TEXT([$1], m4_decr([$2]))]m4_bpatsubst([$1], [\$][#], [$2]))])


dnl  NA_REGEXP_DEPTH(regexp)
dnl  ***************************************************************************
dnl
dnl  Examines a regular expression and returns the number of capturing
dnl  parentheses present
dnl
dnl  The returned number is the highest available sub-match that can be written
dnl  as `\[number]` during a replacement
dnl
dnl  ***************************************************************************
m4_define([NA_REGEXP_DEPTH], [m4_len(m4_bpatsubst(m4_bpatsubst([$1], [\(\\\|)\|\([^\\]\|^\)\(\\\\\)*(\)\|\(\\\)(\|,], [\4]), [[^\\]], []))])


dnl  NA_FOR_EACH_MATCH(string, regexp, macro)
dnl  ***************************************************************************
dnl
dnl  Calls the custom macro `macro` for every occurrence of `regexp` in `string`
dnl
dnl  The text that matches the entire `regexp` and all the sub-strings that
dnl  match its capturing parentheses will be passed to `macro` as arguments.
dnl
dnl  For example,
dnl
dnl      AC_DEFUN([custom_macro], [...foo $1|$2|$3|$4 bar])
dnl      AC_MSG_NOTICE([NA_FOR_EACH_MATCH([blaablabblac],
dnl          [\(b\(l\)\)\(a\)], [custom_macro])])
dnl
dnl  will print:
dnl
dnl      ...foo bla|bl|l|a bar...foo bla|bl|l|a bar...foo bla|bl|l|a bar
dnl
dnl  Requires: `NA_REGEXP_DEPTH()` and `NA_REPEAT_TEXT()`
dnl
dnl  ***************************************************************************
m4_define([NA_FOR_EACH_MATCH],
	[m4_if(m4_bregexp([$1], [$2]), [-1], [],
		[m4_bregexp([$1], [$2], [[]$3([\&]]NA_REPEAT_TEXT([[[,]] \]$[#], NA_REGEXP_DEPTH([$2]))[)])[]NA_FOR_EACH_MATCH(m4_substr([$1], m4_eval(m4_bregexp([$1], [$2]) + m4_len(m4_bregexp([$1], [$2], [\&])))), [$2], [$3])])])


dnl  NA_ASK_REPLACEMENTS(string, regexp, macro)
dnl  ***************************************************************************
dnl
dnl  Replaces every occurrence of `regexp` in `string` with the text returned by
dnl  the custom macro `macro`, invoked for each match
dnl
dnl  The text that matches the entire `regexp` and all the sub-strings that
dnl  match its capturing parentheses will be passed to `macro` as arguments.
dnl
dnl  For example,
dnl
dnl      AC_DEFUN([custom_macro], [XX$3])
dnl      AC_MSG_NOTICE([NA_ASK_REPLACEMENTS([hello you world!!],
dnl          [\(l\|w\)+\(o\)], [custom_macro])])
dnl
dnl  will print:
dnl
dnl      heXXo you XXorld!!
dnl
dnl  Requires: `NA_REGEXP_DEPTH()` and `NA_REPEAT_TEXT()`
dnl
dnl  ***************************************************************************
m4_define([NA_ASK_REPLACEMENTS],
	[m4_if(m4_bregexp([$1], [$2]), [-1], [$1],
		[m4_bpatsubst([$1], [$2], [[]$3([\&]]NA_REPEAT_TEXT([[[,]] \]$[#], NA_REGEXP_DEPTH([$2]))[)])])])



dnl  ***************************************************************************
dnl  Note:  The `NA_` prefix (which stands for "Not Autotools") is used
dnl         with the purpose of avoiding collisions with the default Autotools
dnl `       prefixes `AC_`, AM_`, `AS_`, `AX_`, `LT_`.
dnl  ***************************************************************************


dnl  EOF

