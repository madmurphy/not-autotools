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
dnl  M E S S A G E   B O X E S   F O R   G N U   A U T O C O N F
dnl  **************************************************************************



dnl  NC_MSG_NOTICEBOX(message)
dnl  **************************************************************************
dnl
dnl  Wraps `message` in a text box, then passes it to `AC_MSG_NOTICE()`
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_MSG_NOTICEBOX],
	[AC_MSG_NOTICE([m4_text_wrap([$1 --------------------------------------------------------------------],
		[         | ],
		[--------------------------------------------------------------------],
		[79])])])


dnl  NC_MSG_WARNBOX(problem-description)
dnl  **************************************************************************
dnl
dnl  Wraps `problem-description` in a text box, then passes it to
dnl  `AC_MSG_WARN()`
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_MSG_WARNBOX],
	[AC_MSG_WARN([m4_text_wrap([$1 --------------------------------------------------------------------],
		[         | ],
		[-----------------------------------------------------------],
		[79])])])


dnl  NC_MSG_ERRORBOX(error-description[, exit-status])
dnl  **************************************************************************
dnl
dnl  Wraps `error-description` in a text box, then passes it to
dnl  `AC_MSG_ERROR()`, possibly with `exit-status`
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.2
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_MSG_ERRORBOX],
	[m4_if([$#], [0], [],
		[AC_MSG_ERROR([m4_text_wrap([$1 --------------------------------------------------------------------],
			[         | ],
			[-------------------------------------------------------------],
			[79])]m4_if([$#], [1], [], [, [$2]]))])])


dnl  NC_MSG_FAILUREBOX(error-description[, exit-status])
dnl  **************************************************************************
dnl
dnl  Wraps `error-description` in a text box, then passes it to
dnl  `AC_MSG_FAILURE()`, possibly with `exit-status`
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.2
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_MSG_FAILUREBOX],
	[m4_if([$#], [0], [],
		[AC_MSG_FAILURE([m4_text_wrap([$1 --------------------------------------------------------------------],
			[         | ],
			[-------------------------------------------------------------],
			[79])]m4_if([$#], [1], [], [, [$2]]))])])



dnl  **************************************************************************
dnl  NOTE:  The `NA_` prefix (which stands for "Not Autotools") is used with
dnl         the purpose of avoiding collisions with the default Autotools
dnl         prefixes `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

