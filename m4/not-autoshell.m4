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
dnl  S H E L L - A G N O S T I C   M 4   A B S T R A C T I O N S
dnl  **************************************************************************



dnl  NS_SETVARS(var1[, val1][, var2[, val2][, ... varN[, valN]]])
dnl  **************************************************************************
dnl
dnl  M4 sugar to set the value of many shell variables altogether
dnl
dnl  Same as `var1=val1 var2=val2 ... varN=valN`.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_SETVARS],
	[AS_VAR_SET([$1], [$2]); m4_if(m4_eval([$# > 2]), [1],
		[NS_SETVARS(m4_shift2($@))])])


dnl  NS_GETVAR(var)
dnl  **************************************************************************
dnl
dnl  M4 sugar to get the value of a shell variable
dnl
dnl  Same as `$var`.
dnl
dnl  Example:
dnl
dnl      NS_SETVARS([MY_MESSAGE], ['This is a test'])
dnl      AC_MSG_NOTICE([My message --> NS_GETVAR([MY_MESSAGE])])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
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
dnl  instead of executing a command during the `autoreconf` process, it
dnl  executes it during the `configure` process, when all M4 macros have been
dnl  already expanded. The returned value cannot therefore be stored in another
dnl  macro, but must be stored in a shell variable instead.
dnl
dnl  Example:
dnl
dnl      AC_MSG_NOTICE([Today is NS_GETOUT([date])])
dnl      AC_MSG_NOTICE([NS_GETOUT([echo 'This is a test'])])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
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
dnl      NS_SETVARS([FIRST_VAR], ['first value'],
dnl          [SECOND_VAR], ['second value'],
dnl          [THIRD_VAR], ['third value'])
dnl
dnl      NS_UNSET([FIRST_VAR], [SECOND_VAR], [THIRD_VAR])
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_UNSET],
	[m4_ifnblank([$1], [AS_UNSET(m4_quote(m4_normalize([$1])));])m4_if([$#], [1], [], [NS_UNSET(m4_shift($@))])])


dnl  NS_MOVEVAR(destination, source)
dnl  **************************************************************************
dnl
dnl  Copies the value of `source` into the shell variable `destination`, then
dnl  unsets `source` if this is set
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_MOVEVAR],
	[{ AS_VAR_COPY([$1], [$2]); AS_UNSET([$2]); }])


dnl  NS_REPLACEVAR(destination, source)
dnl  **************************************************************************
dnl
dnl  If `source` is set, copies the value of `source` into the shell variable
dnl  `destination` then unsets `source`; if `source` is not set but
dnl  `destination` is set, unsets `destination`
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_REPLACEVAR],
	[{ @S|@{$2+:} false && { AS_VAR_COPY([$1], [$2]); AS_UNSET([$2]); } || AS_UNSET([$1]) }])


dnl  NS_FOR(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create a "for" shell loop
dnl
dnl  For example:
dnl
dnl      # Iterate over all `configure` arguments and check if `--docdir` has
dnl      # been given
dnl      NS_FOR([_this_arg_],
dnl          [AS_CASE([${_this_arg_}], [--docdir=*], [
dnl              AS_VAR_SET([is_auto_docdir], [no])
dnl              NS_BREAK
dnl          ])])
dnl
dnl      AS_IF([test "x${is_auto_docdir}" != xno],
dnl          [AC_MSG_NOTICE([Using default value for <docdir>])],
dnl          [AC_MSG_NOTICE([Using user-given value for <docdir>])])
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_FOR],
	[{ for $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_WHILE(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create a "while" shell loop
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_WHILE],
	[{ while $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_UNTIL(initialization, statement)
dnl  **************************************************************************
dnl
dnl  M4 sugar to create an "until" shell loop
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_UNTIL],
	[{ until $1; do[]m4_newline()$2[]m4_newline()done }])


dnl  NS_BREAK
dnl  **************************************************************************
dnl
dnl  M4 sugar that expands to a shell "break" command, to be used within loops
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
AC_DEFUN([NS_BREAK],
	[m4_newline()break;m4_newline()])


dnl  NS_CONTINUE
dnl  **************************************************************************
dnl
dnl  M4 sugar that expands to a shell "continue" command, to be used within
dnl  loops
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
AC_DEFUN([NS_CONTINUE],
	[m4_newline()continue;m4_newline()])


dnl  NS_TEST_EQ(left1, right1[, left2, right2[, ... leftN, rightN]])
dnl  **************************************************************************
dnl
dnl  Checks if all equality tests have succeeded and triggers `true` or `false`
dnl  accordingly
dnl
dnl  For example,
dnl
dnl      AS_VAR_SET([first], [yes])
dnl      AS_VAR_SET([second], [no])
dnl
dnl      AS_IF([NS_TEST_EQ(
dnl              [${first}], [yes],
dnl              [${second}], [no])],
dnl          [AC_MSG_NOTICE([Test passed])],
dnl          [AC_MSG_NOTICE([Test not passed])])
dnl
dnl  will print
dnl
dnl      Test passed
dnl
dnl  To understand how the macro works, the following code
dnl
dnl      NS_TEST_EQ([one], [two], [three], [four])
dnl
dnl  expands to
dnl
dnl      test "xonethree" = "xtwofour"
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEST_EQ],
	[m4_if([$#], [0], [], [$#], [1], [], [$#], [2],
		[test "x[]_AS_QUOTE([[$1]])" = "x[]_AS_QUOTE([[$2]])"],
		[NS_TEST_EQ([$1$3], [$2$4]m4_if([$#], [3], [], [$#], [4], [],
			[, m4_shift3(m4_shift($@))]))])])


dnl  NS_TEST_NE(left1, right1[, left2, right2[, ... leftN, rightN]])
dnl  **************************************************************************
dnl
dnl  Checks if at least one equality test has failed and triggers `true` or
dnl  `false` accordingly
dnl
dnl  For example,
dnl
dnl      AS_VAR_SET([first], [yes])
dnl      AS_VAR_SET([second], [no])
dnl
dnl      AS_IF([NS_TEST_NE(
dnl              [${first}], [yes],
dnl              [${second}], [no])],
dnl          [AC_MSG_NOTICE([Test passed])],
dnl          [AC_MSG_NOTICE([Test not passed])])
dnl
dnl  will print
dnl
dnl      Test not passed
dnl
dnl  To understand how the macro works, the following code
dnl
dnl      NS_TEST_NE([one], [two], [three], [four])
dnl
dnl  expands to
dnl
dnl      test "xonethree" != "xtwofour"
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEST_NE],
	[m4_if([$#], [0], [], [$#], [1], [], [$#], [2],
		[test "x[]_AS_QUOTE([[$1]])" != "x[]_AS_QUOTE([[$2]])"],
		[NS_TEST_NE([$1$3], [$2$4]m4_if([$#], [3], [], [$#], [4], [],
			[, m4_shift3(m4_shift($@))]))])])


dnl  NS_TEST_AEQ(string1, string2[, string3[, ... stringN]])
dnl  **************************************************************************
dnl
dnl  Check if all arguments expand to the same string and triggers `true` or
dnl  `false` accordingly
dnl
dnl  For example,
dnl
dnl      AC_HEADER_STDBOOL
dnl
dnl      AC_CHECK_HEADERS([stddef.h stdint.h stdio.h stdlib.h])
dnl
dnl      AS_IF([NS_TEST_AEQ([yes],
dnl          [${ac_cv_header_stdio_h}], [${ac_cv_header_stddef_h}],
dnl          [${ac_cv_header_stdbool_h}], [${ac_cv_header_stdint_h}],
dnl          [${ac_cv_header_stdlib_h}])],
dnl              [AC_MSG_NOTICE([Test passed])],
dnl              [AC_MSG_ERROR([Test not passed])])
dnl
dnl  will likely print
dnl
dnl      Test passed
dnl
dnl  To understand how the macro works, the following code
dnl
dnl      NS_TEST_AEQ([one], [two], [three], [four])
dnl
dnl  expands to
dnl
dnl      test "xtwothreefour" = "xoneoneone"
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEST_AEQ],
	[test "x[]_AS_QUOTE(m4_dquote(m4_joinall(, m4_shift($@))))" = "x[]_AS_QUOTE(m4_dquote(m4_for([], [2], [$#], [1], [[$1]])))"])


dnl  NS_TEST_NAE(string1, string2[, string3[, ... stringN]])
dnl  **************************************************************************
dnl
dnl  Check if all arguments do **not** expand to the same string and triggers
dnl  `true` or `false` accordingly
dnl
dnl  For example,
dnl
dnl      AC_HEADER_STDBOOL
dnl
dnl      AC_CHECK_HEADERS([stddef.h stdint.h stdio.h stdlib.h])
dnl
dnl      AS_IF([NS_TEST_NAE([yes],
dnl          [${ac_cv_header_stdio_h}], [${ac_cv_header_stddef_h}],
dnl          [${ac_cv_header_stdbool_h}], [${ac_cv_header_stdint_h}],
dnl          [${ac_cv_header_stdlib_h}])],
dnl              [AC_MSG_ERROR([Test not passed])],
dnl              [AC_MSG_NOTICE([Test passed])])
dnl
dnl  will likely print
dnl
dnl      Test passed
dnl
dnl  To understand how the macro works, the following code
dnl
dnl      NS_TEST_NAE([one], [two], [three], [four])
dnl
dnl  expands to
dnl
dnl      test "xtwothreefour" != "xoneoneone"
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEST_NAE],
	[test "x[]_AS_QUOTE(m4_dquote(m4_joinall(, m4_shift($@))))" != "x[]_AS_QUOTE(m4_dquote(m4_for([], [2], [$#], [1], [[$1]])))"])


dnl  NS_TEXT_WRAP(text[, max-width=79])
dnl  **************************************************************************
dnl
dnl  M4 sugar to wrap a text into a fixed-width column
dnl
dnl  This macro is similar to the Unix `fmt` command, but it is implemented
dnl  using only `sed`. The `text` argument is passed verbatim, without shell
dnl  quoting. For a version that treats the `text` argument in the same way as
dnl  `AC_MSG_NOTICE()` does, see `NS_TEXT_WRAP_UNQUOTED()`.
dnl
dnl  For example, the following code:
dnl
dnl      AS_VAR_SET([INCIPIT],
dnl          ['Lorem ipsum dolor sit amet, consectetur adipiscing elit.'])
dnl
dnl      NS_TEXT_WRAP(["${INCIPIT}"' Phasellus sit amet enim ac tellus aliquam
dnl      lacinia. Nullam iaculis imperdiet lorem, ac consectetur nisi vulputate
dnl      et. Proin a eros at orci pharetra fringilla non accumsan nulla. Fusce
dnl      sem dolor, facilisis ac vestibulum a, lacinia sed arcu.'], [40])
dnl
dnl  will generate the following shell output:
dnl
dnl      Lorem ipsum dolor sit amet, consectetur
dnl      adipiscing elit. Phasellus sit amet enim
dnl      ac tellus aliquam lacinia. Nullam
dnl      iaculis imperdiet lorem, ac consectetur
dnl      nisi vulputate et. Proin a eros at orci
dnl      pharetra fringilla non accumsan nulla.
dnl      Fusce sem dolor, facilisis ac vestibulum
dnl      a, lacinia sed arcu.
dnl
dnl  The shell code produced by this macro is safely contained within curly
dnl  brackets, so that its output can be easily captured or piped, as in the
dnl  following example,
dnl
dnl      AS_VAR_SET([FOO],
dnl          ["$(NS_TEXT_WRAP(['Hello world!'], [5]))"])
dnl
dnl      AS_ECHO("${FOO}")
dnl
dnl  which will print the following text:
dnl
dnl      Hello
dnl      world!
dnl
dnl  If `text` does not contain any shell expansions you should use
dnl  `AS_ECHO(['m4_text_wrap(m4_quote(m4_bpatsubst([TEXT GOES HERE], ['], ['\\''])),,, [MAX-WIDTH GOES HERE])'])`
dnl  instead of `NS_TEXT_WRAP()`, so that the `configure` script receives a
dnl  literal instead of a `sed` substitution to perform each time it is run.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEXT_WRAP], [{
	AC_REQUIRE([AC_PROG_SED])
	_newtxt_=$1
	while :
	do
		_oldtxt_="${_newtxt_}"
		_newtxt_="$(echo -n "${_oldtxt_}" | ${SED} '
			s/^..\{'m4_default_nblank([$2], ['79'])'\}/&\x00/;
			s/^\(\S\+\)\x00\(\S*\)\s\|\(^\|\s\)\(\S*\)\x00/\1\2\x00\4/;
			s/^\x00//;
			s/\x00/\n/;
		')"
		test "x${_newtxt_}" != "x${_oldtxt_}" || break
	done
	echo "${_newtxt_}"
}])


dnl  NS_TEXT_WRAP_UNQUOTED(text[, max-width=79])
dnl  **************************************************************************
dnl
dnl  M4 sugar to wrap a text into a fixed-width column
dnl
dnl  Quote-safe version of `NS_TEXT_WRAP()`
dnl
dnl  For example, the following code:
dnl
dnl      AS_VAR_SET([INCIPIT],
dnl          ['Lorem ipsum dolor sit amet, consectetur adipiscing elit.'])
dnl
dnl      NS_TEXT_WRAP_UNQUOTED([${INCIPIT} Phasellus sit amet enim ac tellus
dnl      aliquam lacinia. Nullam iaculis imperdiet lorem, ac consectetur nisi
dnl      vulputate et. Proin a eros at orci pharetra fringilla non accumsan
dnl      nulla. Fusce sem dolor, facilisis ac vestibulum a, lacinia sed arcu.],
dnl      [40])
dnl
dnl  will generate the following shell output:
dnl
dnl      Lorem ipsum dolor sit amet, consectetur
dnl      adipiscing elit. Phasellus sit amet enim
dnl      ac tellus aliquam lacinia. Nullam
dnl      iaculis imperdiet lorem,ac consectetur
dnl      nisi vulputate et. Proin a eros at orci
dnl      pharetra fringilla non accumsan nulla.
dnl      Fusce sem dolor,facilisis ac vestibulum
dnl      a,lacinia sed arcu.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEXT_WRAP_UNQUOTED],
	[m4_if([$#], [0],
		[NS_TEXT_WRAP],
		[NS_TEXT_WRAP(["]m4_dquote(_AS_QUOTE([[$1]]))["]m4_if([$#], [1], [], [, $2]))])])


dnl  NS_TEXT_WRAP_CENTER(text[, max-width=60[, screen-width=79]])
dnl  **************************************************************************
dnl
dnl  M4 sugar to wrap a text into a centered fixed-width column
dnl
dnl  This macro calls `NS_TEXT_WRAP()` and then centers each line. The `text`
dnl  argument is passed verbatim, without shell quoting.
dnl
dnl  For example, the following code:
dnl
dnl      AS_VAR_SET([INCIPIT],
dnl          ['Lorem ipsum dolor sit amet, consectetur adipiscing elit.'])
dnl
dnl      NS_TEXT_WRAP_CENTER(["${INCIPIT}"' Phasellus sit amet enim ac tellus
dnl      aliquam lacinia. Nullam iaculis imperdiet lorem, ac consectetur nisi
dnl      vulputate et. Proin a eros at orci pharetra fringilla non accumsan
dnl      nulla. Fusce sem dolor, facilisis ac vestibulum a, lacinia sed arcu.'],
dnl      [40], [70])
dnl
dnl  will generate the following shell output:
dnl
dnl                     Lorem ipsum dolor sit amet, consectetur
dnl                     adipiscing elit. Phasellus sit amet enim
dnl                        ac tellus aliquam lacinia. Nullam
dnl                     iaculis imperdiet lorem, ac consectetur
dnl                     nisi vulputate et. Proin a eros at orci
dnl                      pharetra fringilla non accumsan nulla.
dnl                     Fusce sem dolor, facilisis ac vestibulum
dnl                               a, lacinia sed arcu.
dnl
dnl  This macro can be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NS_TEXT_WRAP()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NS_TEXT_WRAP_CENTER],
	[{ NS_TEXT_WRAP([$1], m4_ifblank([$2], [['60']], [[$2]])) | while read _line_; do test "${@%:@_line_}" -ge m4_ifblank([$3], ['79'], [$3]) && echo "${_line_}" || echo "$(printf "%$(expr '(' m4_ifblank([$3], ['79'], [$3]) '-' "${@%:@_line_}" ')' '/' 2)s")${_line_}"
done; }])



dnl  **************************************************************************
dnl  NOTE:  The `NS_` prefix (which stands for "Not autoShell") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

