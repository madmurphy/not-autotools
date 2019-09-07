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
dnl  M 4 S U G A R   E X T E N S I O N S
dnl  ***************************************************************************



dnl  nm4_switch(text0[, text1, if-matched1[, textN, if-matchedN[, default]]])
dnl  ***************************************************************************
dnl
dnl  Switches among literals
dnl
dnl  Same syntax of `AS_CASE()`, but it operates on M4 macros rather than shell
dnl  variables. Furthermore, differently than in `AS_CASE()`, the string
dnl  comparisons here are performed literally (patterns are not followed). For
dnl  using patterns in string comparisons, see `nm4_case()`.
dnl
dnl  Example:
dnl
dnl      AC_DEFUN([DIST_STATUS],
dnl          [nm4_switch(NM_GET_AM_VAR([USER]),
dnl              [madmurphy],
dnl                  [official release],
dnl              [rose],
dnl                  [semi-official release],
dnl              [charlie],
dnl                  [abusive release],
dnl                  [unofficial release])])
dnl      AC_MSG_NOTICE([Distribution status: DIST_STATUS])
dnl
dnl  For the `NM_GET_AM_VAR()` macro, see `not-automake.m4`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_switch], [m4_if(m4_eval([$# < 2]), [0], [m4_if([$2], [$1], [m4_normalize([$3])], [m4_if(m4_eval([$# > 4]), [1], [nm4_switch([$1], m4_shift3($@))], [m4_if(m4_eval([$# & 1]), [0], [m4_normalize(m4_argn([$#], $@))])])])])])


dnl  nm4_case(text[, pattern1, if-matched1[, patternN, if-matchedN[, default]]])
dnl  ***************************************************************************
dnl
dnl  Switches among patterns
dnl
dnl  Same syntax of `AS_CASE()`, but it operates on M4 macros rather than shell
dnl  variables. Patterns are supported and must follow the same syntax used in
dnl  the GNU M4 `regexp()` macro (see:
dnl  https://www.gnu.org/software/m4/manual/m4-1.4.14/html_node/Regexp.html).
dnl  For literal string comparisons without pattern support, see `nm4_switch()`.
dnl
dnl  Example:
dnl
dnl      AC_DEFUN([SHELL_TYPE],
dnl          [nm4_case(NM_GET_AM_VAR([SHELL]),
dnl              [/\w*csh$],
dnl                  [C shell],
dnl              [/\w*sh$],
dnl                  [Other POSIX non-C shell],
dnl                  [Unknown shell])])
dnl      AC_MSG_NOTICE([Maintainer's shell type: SHELL_TYPE])
dnl
dnl  For the `NM_GET_AM_VAR()` macro, see `not-automake.m4`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_case], [m4_if(m4_eval([$# < 2]), [0], [m4_if(m4_eval(m4_bregexp([$1], [$2]) > -1), [1], [m4_normalize([$3])], [m4_if(m4_eval([$# > 4]), [1], [nm4_case([$1], m4_shift3($@))], [m4_if(m4_eval([$# & 1]), [0], [m4_normalize(m4_argn([$#], $@))])])])])])


dnl  nm4_in_args(target, string1[, string2[, ... stringN ]])
dnl  ***************************************************************************
dnl
dnl  Searches for the first duplicate of the argument `target` among all the
dnl  other arguments
dnl
dnl  This macro expands to `1` if a duplicate is found, to `0` otherwise.
dnl
dnl  For example,
dnl
dnl      nm4_in_args([bar], [foo], [bar], [hello])
dnl
dnl  will expand to `1`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_in_args], [m4_if(m4_eval([$# < 2]), [1], [0], [m4_if([$1], [$2], [1], [m4_if(m4_eval([$# > 2]), [1], [nm4_in_args([$1], m4_shift2($*))], [0])])])])


dnl  nm4_in(target, list)
dnl  ***************************************************************************
dnl
dnl  Searches for the first occurence of `target` in the comma-separated list
dnl  `list`
dnl
dnl  This macro expands to `1` if `target` is found, to `0` otherwise.
dnl
dnl  For example,
dnl
dnl      nm4_in([PATH], [NM_ENVIRONMENT_KEYS])
dnl
dnl  will most likely expand to `1` (for the `NM_ENVIRONMENT_KEYS` macro, see
dnl  `not-automake.m4`).
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  Note: If you have already included `nm4_in_args()` in your scipts you can
dnl        use the following shorter definition of `nm4_in()`:
dnl
dnl            m4_define([nm4_in], [nm4_in_args([$1], $2)])
dnl
dnl  ***************************************************************************
m4_define([nm4_in], [m4_if(m4_eval(m4_count($2) < 1), [1], [0], [m4_if(m4_argn(1, $2), [$1], [1], [m4_if(m4_eval(m4_count($2) > 1), [1], [nm4_in([$1], [m4_shift($2)])], [0])])])])


dnl  nm4_lambda(macro_body)
dnl  ***************************************************************************
dnl
dnl  Creates an anonymous macro on the fly, able to be passed as a callback
dnl  argument
dnl
dnl  Example:
dnl
dnl      AC_DEFUN([MISSING_PROGRAMS], [[find], [xargs], [sed]])
dnl      AC_MSG_ERROR([Install first m4_map([nm4_lambda(["$1", ])], [MISSING_PROGRAMS])then proceed.])
dnl
dnl  By using the `nm4_anon()` keyword, the macro body can invoke itself
dnl  repeatedly (recursion). For example,
dnl
dnl      AC_MSG_NOTICE([nm4_lambda([[{$1}]m4_if(m4_eval($# > 1), [1], [nm4_anon(m4_shift($*))])])([one], [two], [three], [four])])
dnl
dnl  will print
dnl
dnl      {one}{two}{three}{four}
dnl
dnl  The `nm4_anon` keyword is available both within and outside the macro body
dnl  (in this last case it will point to the last lambda macro called). For
dnl  example,
dnl
dnl      nm4_lambda([[{$1}]m4_if(m4_eval($# > 1), [1], [nm4_anon(m4_shift($*))])])([one], [two], [three], [four])
dnl      nm4_anon([five], [six], [seven], [eight])
dnl
dnl  will print
dnl
dnl      {one}{two}{three}{four}
dnl      {five}{six}{seven}{eight}
dnl
dnl  It is suggested, although not strictly needed, to call `nm4_unlambda` as
dnl  soon as the lambda macro terminates its function, in order to delete the
dnl  `nm4_anon` keyword from the global scope. So, for example:
dnl  
dnl      nm4_lambda([[{$1}]m4_if(m4_eval($# > 1), [1], [nm4_anon(m4_shift($*))])])([one], [two], [three], [four])
dnl      nm4_anon([five], [six], [seven], [eight])
dnl      nm4_unlambda
dnl      nm4_anon([nine], [ten], [eleven], [twelve])
dnl  
dnl  will print:
dnl  
dnl      {one}{two}{three}{four}  
dnl      {five}{six}{seven}{eight} 
dnl      nm4_anon(nine, ten, eleven, twelve) 
dnl
dnl  If the anonymous macro needs to be invoked only once, the `nm4_unlambda`
dnl  macro can be invoked directly from the macro body itself:
dnl
dnl      AC_MSG_NOTICE([Some quoted text: nm4_lambda(["$1"][nm4_unlambda])([Hello world!]).])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Optionally requires: `nm4_unlambda` (for unregistering the lamba macro)
dnl
dnl  ***************************************************************************
m4_define([nm4_lambda], [m4_define([nm4_anon], [$1])][nm4_anon])


dnl  nm4_unlambda
dnl  ***************************************************************************
dnl
dnl  Forgets the last lambda macro created
dnl
dnl  See `nm4_lambda()` for details.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl  Optionally requires: `nm4_lambda()` (for registering lamba macros)
dnl
dnl  ***************************************************************************
m4_define([nm4_unlambda], [m4_ifdef([nm4_anon], [m4_undefine([nm4_anon])])])


dnl  nm4_define_substrings_as(string, regexp, macro0[, macro1[, ... macroN ]])
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
dnl      nm4_define_substrings_as(
dnl          m4_include([VERSION]),
dnl          [\([0-9]+\)\s*\.\s*\([0-9]+\)\s*\.\s*\([0-9]+\)],
dnl          [VERSION_STR], [VERSION_MAJ], [VERSION_MIN], [VERSION_REV]      
dnl      )
dnl      
dnl      AC_INIT([foo], VERSION_MAJ[.]VERSION_MIN[.]VERSION_REV)
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_define_substrings_as],
	[m4_if(m4_eval([$# > 2]), [1],
		[m4_if(m4_normalize(m4_argn([$#], $*)), [], [],
			[m4_bregexp([$1], [$2], [m4_define(m4_normalize(m4_argn([$#], $*)), \]m4_if([$#], [3], [&], m4_eval([$# - 3]))[)])])[]m4_if(m4_eval([$# > 3]), [1], [nm4_define_substrings_as(m4_reverse(m4_shift(m4_reverse($@))))])])])


dnl  nm4_repeat(text, n_times)
dnl  ***************************************************************************
dnl
dnl  Repeats `text` `n_times`
dnl
dnl  Every occurrence of `$#` within `text` will be replaced with the current
dnl  index. For example,
dnl
dnl      nm4_repeat([foo $#...], [4])
dnl
dnl  will expand to:
dnl
dnl      foo 1...foo 2...foo 3...foo 4...
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_repeat], [m4_if(m4_eval([$2] > 0), [1], [nm4_repeat([$1], m4_decr([$2]))]m4_bpatsubst([$1], [\$][#], [$2]))])


dnl  nm4_redepth(regexp)
dnl  ***************************************************************************
dnl
dnl  Examines a regular expression and returns the number of capturing
dnl  parentheses present
dnl
dnl  The returned number is the highest available sub-match that can be written
dnl  as `\[number]` during a replacement
dnl
dnl  For example,
dnl
dnl      nm4_redepth([\([0-9]+\)\.\([0-9]+\)\.\([0-9]+\)])
dnl
dnl  expands to `3`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
m4_define([nm4_redepth], [m4_len(m4_bpatsubst(m4_bpatsubst([$1], [\(\\\|)\|\([^\\]\|^\)\(\\\\\)*(\)\|\(\\\)(\|,], [\4]), [[^\\]], []))])


dnl  nm4_for_each_match(string, regexp, macro)
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
dnl      AC_MSG_NOTICE([nm4_for_each_match([blaablabblac],
dnl          [\(b\(l\)\)\(a\)], [custom_macro])])
dnl
dnl  will print:
dnl
dnl      ...foo bla|bl|l|a bar...foo bla|bl|l|a bar...foo bla|bl|l|a bar
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `nm4_redepth()` and `nm4_repeat()`
dnl
dnl  ***************************************************************************
m4_define([nm4_for_each_match],
	[m4_if(m4_bregexp([$1], [$2]), [-1], [],
		[m4_bregexp([$1], [$2], [[]$3([\&]]nm4_repeat([[[,]] \]$[#], nm4_redepth([$2]))[)])[]nm4_for_each_match(m4_substr([$1], m4_eval(m4_bregexp([$1], [$2]) + m4_len(m4_bregexp([$1], [$2], [\&])))), [$2], [$3])])])


dnl  nm4_get_replacements(string, regexp, macro)
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
dnl      AC_MSG_NOTICE([nm4_get_replacements([hello you world!!],
dnl          [\(l\|w\)+\(o\)], [custom_macro])])
dnl
dnl  will print:
dnl
dnl      heXXo you XXorld!!
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `nm4_redepth()` and `nm4_repeat()`
dnl
dnl  ***************************************************************************
m4_define([nm4_get_replacements],
	[m4_if(m4_bregexp([$1], [$2]), [-1], [$1],
		[m4_bpatsubst([$1], [$2], [[]$3([\&]]nm4_repeat([[[,]] \]$[#], nm4_redepth([$2]))[)])])])



dnl  ***************************************************************************
dnl  Note:  The `nm4_` prefix (which stands for "Not M4") is used with the
dnl         purpose of avoiding collisions with the default GNU M4sugar
dnl         prefix `m4_`.
dnl  ***************************************************************************


dnl  EOF

