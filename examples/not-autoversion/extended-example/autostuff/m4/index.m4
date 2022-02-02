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



dnl  n4_has(list, check1, if-found1[, ... checkN, if-foundN[, if-not-found]])
dnl  **************************************************************************
dnl
dnl  Check if a list contains one or more elements
dnl
dnl  From: not-autotools/m4/not-m4sugar.m4
dnl  Version: 1.0.0
dnl
m4_define([n4_has],
	[m4_if([$#], [0], [], [$#], [1], [], [$#], [2], [],
		[m4_if(m4_argn(1, $1), [$2], [$3], [$#], [3], [], [$#], [4],
			[m4_if(m4_count($1), [1],
				[$4],
				[n4_has(m4_dquote(m4_shift($1)), m4_shift($@))])],
			[m4_if(m4_count($1), [1],
				[n4_has([$1], m4_shift3($@))],
				[n4_has(m4_dquote(m4_shift($1)), [$2], [$3],
					[n4_has([$1], m4_shift3($@))])])])])])


dnl  n4_case_in(text, list1, if-found1[, ... listN, if-foundN], [if-not-found])
dnl  **************************************************************************
dnl
dnl  Searches for the first occurrence of `text` in each comma-separated list
dnl  `listN`
dnl
dnl  From: not-autotools/m4/not-m4sugar.m4
dnl  Version: 1.0.1
dnl
m4_define([n4_case_in],
	[m4_if([$#], [0], [], [$#], [1], [], [$#], [2], [],
		[m4_if(m4_argn([1], $2), [$1],
			[$3],
			[m4_if(m4_count($2), [1],
				[m4_if([$#], [3], [], [$#], [4],
					[$4],
					[n4_case_in([$1], m4_shift3($@))])],
				[n4_case_in([$1],
					m4_dquote(m4_shift($2)),
					m4_shift2($@))])])])])


m4_include([autostuff/m4/not-autoversion.m4])
m4_include([autostuff/m4/not-extended-config.m4])



dnl  **************************************************************************
dnl  NOTE:  The `NR_` prefix (which stands for "Not autoReconf") and the `NC_`
dnl         prefix (which stands for "Not autoConf") are used with the purpose
dnl         of avoiding collisions with the default Autotools prefixes `AC_`,
dnl         `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

