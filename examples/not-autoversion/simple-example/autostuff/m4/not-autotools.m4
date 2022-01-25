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


dnl  NR_RECORD_HISTORY([root], event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Automatically assigns version numbers to all the releases of an
dnl  unversioned history declared in a ChangeLog-like style
dnl
dnl  Requires: `NR_BUMP_VSTATE()`, `NR_GET_EVENT_VSTATE()`
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_RECORD_HISTORY], [dnl
dnl
dnl
dnl  NR_HISTORY_ROOT_VSTATE([event-name])
dnl  **************************************************************************
dnl  The initial version state expanded from the `root` argument passed to
dnl  `NR_RECORD_HISTORY()`
m4_define([NR_HISTORY_ROOT_VSTATE],
	m4_dquote(m4_default_nblank_quoted(m4_argn([1], $1), [0]),
		m4_default_nblank(m4_quote(m4_argn([2], $1)),
			[m4_if(m4_eval(m4_argn([1], $1)[ + 0 > 0]), [1],
				[0],
				[1])]),
		m4_default_nblank_quoted(m4_argn([3], $1), [0]),
		m4_default_nblank_quoted(m4_argn([4], $1), [0]),
		m4_default_nblank_quoted(m4_argn([5], $1), [0]),
		m4_default_nblank_quoted(m4_argn([6], $1), [0]),
		m4_default_nblank_quoted(m4_argn([7], $1), [0])))dnl
dnl
dnl
dnl  NR_HISTORY_EVENTS()
dnl  **************************************************************************
dnl  The entire history, without information about the root version
m4_define([NR_HISTORY_EVENTS],
	[m4_shift($@)])dnl
dnl
dnl  NR_HISTORY_GET_EVENT_VSTATE([event-name])
dnl  **************************************************************************
dnl
dnl  Get the version of a particular event in the release history by using its
dnl  name -- defaults to `NR_HISTORY_CURRENT_VSTATE` when no event is
dnl  found
dnl
m4_define([NR_HISTORY_GET_EVENT_VSTATE],
	[NR_GET_EVENT_VSTATE(]m4_dquote([$][1])[,
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS)])dnl
dnl
dnl  NR_HISTORY_CURRENT_EVENT_NAME()
dnl  **************************************************************************
dnl  The name assigned to the latest history event (typically `CURRENT`)
m4_define([NR_HISTORY_CURRENT_EVENT_NAME],
	m4_quote(m4_argn([1], m4_unquote(m4_argn([$#], $@)))))dnl
dnl
dnl
dnl  NR_HISTORY_CURRENT_VSTATE()
dnl  **************************************************************************
dnl  The current version state
m4_define([NR_HISTORY_CURRENT_VSTATE],
	m4_quote(NR_HISTORY_GET_EVENT_VSTATE))dnl
dnl
dnl
dnl  NR_PROJECT_MAJVER()
dnl  **************************************************************************
dnl  The project's major version number -- equal to `NR_BINARY_MAJVER` plus one
m4_define([NR_PROJECT_MAJVER],
	m4_quote(m4_argn([1], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_PROJECT_MINVER()
dnl  **************************************************************************
dnl  The project's minor version number
m4_define([NR_PROJECT_MINVER],
	m4_quote(m4_argn([2], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_PROJECT_MICVER()
dnl  **************************************************************************
dnl  The project's micro version number
m4_define([NR_PROJECT_MICVER],
	m4_quote(m4_argn([3], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_PROJECT_VERSION()
dnl  **************************************************************************
dnl  The project's version string
m4_define([NR_PROJECT_VERSION],
	m4_quote(NR_PROJECT_MAJVER.NR_PROJECT_MINVER.NR_PROJECT_MICVER))dnl
dnl
dnl
dnl  NR_BINARY_MAJVER()
dnl  **************************************************************************
dnl  The binary major version number -- equal to `NR_PROJECT_MAJVER` minus one
m4_define([NR_BINARY_MAJVER],
	m4_if(m4_eval(NR_PROJECT_MAJVER[ > 0]), [1],
		[m4_quote(m4_decr(NR_PROJECT_MAJVER))], [[0]]))dnl
dnl
dnl
dnl  NR_BINARY_MINVER()
dnl  **************************************************************************
dnl  The binary minor version number -- synonym of `NR_INTERFACES_SUPPORTED`
m4_define([NR_BINARY_MINVER],
	m4_quote(m4_argn([6], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_BINARY_MICVER()
dnl  **************************************************************************
dnl  The binary micro version number -- synonym of `NR_IMPLEMENTATION_NUM`
m4_define([NR_BINARY_MICVER],
	m4_quote(m4_argn([5], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_BINARY_VERSION()
dnl  **************************************************************************
dnl  The compiled binary's version string
m4_define([NR_BINARY_VERSION],
	m4_quote(NR_BINARY_MAJVER.NR_BINARY_MINVER.NR_BINARY_MICVER))dnl
dnl
dnl
dnl  NR_INTERFACE_NUM()
dnl  **************************************************************************
dnl  libtool version info's `current` field
m4_define([NR_INTERFACE_NUM],
	m4_quote(m4_argn([4], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_INTERFACES_SUPPORTED()
dnl  **************************************************************************
dnl  libtool version info's `age` field -- synonym of `NR_BINARY_MINVER`
m4_define([NR_INTERFACES_SUPPORTED],
	m4_quote(NR_BINARY_MINVER))dnl
dnl
dnl
dnl  NR_IMPLEMENTATION_NUM()
dnl  **************************************************************************
dnl  libtool version info's `revision` field -- synonym of `NR_BINARY_MICVER`
m4_define([NR_IMPLEMENTATION_NUM],
	m4_quote(NR_BINARY_MICVER))dnl
dnl
dnl
dnl  NR_LIBTOOL_VERSION_INFO()
dnl  **************************************************************************
dnl  GNU libtool version info
m4_define([NR_LIBTOOL_VERSION_INFO],
	m4_quote(NR_INTERFACE_NUM:NR_IMPLEMENTATION_NUM:NR_INTERFACES_SUPPORTED))dnl
dnl
dnl
dnl  NR_SOURCE_AGE()
dnl  **************************************************************************
dnl  The number of source-only changes since the last interface change
m4_define([NR_SOURCE_AGE],
	m4_quote(m4_argn([7], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
])


dnl  NR_BUMP_VSTATE(project-major, project-minor, project-micro, current,
dnl                 revision, age, source-age, change1, change2, ... changeN)
dnl  **************************************************************************
dnl
dnl  Applies one or more changes to a version state
dnl
dnl  Requires: `n4_has()`
dnl
m4_define([NR_BUMP_VSTATE],
	[n4_has([$8],
		[FORK],
			[n4_has([$8],
				[LAUNCH],
					[1, 0, 0, 0, 0, 0, 0],
					[0, 1, 0, 0, 0, 0, 0])],
			[m4_if(m4_eval([$1 > 0]), [1],
				[n4_has([$8],
					[DEPARTURE],
						[m4_incr([$1]), 0, 0, m4_incr([$4]), 0, 0, 0],
					[INTERFACE],
						[[$1], m4_incr([$2]), 0, m4_incr([$4]), 0, m4_incr([$6]), 0],
					[IMPLEMENTATION],
						[n4_has([$8],
							[HEADERS],
								[[$1], m4_incr([$2]), 0, [$4], m4_incr([$5]), [$6], m4_incr([$7])],
							[MILESTONE],
								[[$1], m4_incr([$2]), 0, [$4], m4_incr([$5]), [$6], [$7]],
								[[$1], [$2], m4_incr([$3]), [$4], m4_incr([$5]), [$6], [$7]])],
					[HEADERS],
						[[$1], m4_incr([$2]), 0, [$4], [$5], [$6], m4_incr([$7])],
					[MILESTONE],
						[[$1], m4_incr([$2]), 0, [$4], [$5], [$6], [$7]],
					[MISCELLANEA],
						[[$1], [$2], m4_incr([$3]), [$4], [$5], [$6], [$7]],
						[[$1], [$2], [$3], [$4], [$5], [$6], [$7]])],
				[n4_has([$8],
					[LAUNCH],
						[1, 0, 0, 0, 0, 0, 0],
					[DEPARTURE],
						[0, m4_incr([$2]), 0, 0, 0, 0, 0],
					[INTERFACE],
						[0, m4_incr([$2]), 0, 0, 0, 0, 0],
					[HEADERS],
						[0, m4_incr([$2]), 0, 0, 0, 0, 0],
					[MILESTONE],
						[0, m4_incr([$2]), 0, 0, 0, 0, 0],
					[IMPLEMENTATION],
						[0, [$2], m4_incr([$3]), 0, 0, 0, 0],
					[MISCELLANEA],
						[0, [$2], m4_incr([$3]), 0, 0, 0, 0],
						[0, [$2], [$3], 0, 0, 0, 0])])])])


dnl  NR_GET_EVENT_VSTATE(event-name, root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_GET_EVENT_VSTATE()`, but not bound to any particular
dnl  history (the desired history must be passed explicitly)
dnl
dnl  Requires: `NR_BUMP_VSTATE()`
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_GET_EVENT_VSTATE],
	[m4_if([$#], [1], [], [$#], [2], [$2], [$#], [3],
			[NR_BUMP_VSTATE($2, m4_dquote(m4_shift($3)))],
			[m4_if([$1], m4_argn([1], $3),
				[NR_BUMP_VSTATE($2, m4_dquote(m4_shift($3)))],
				[NR_GET_EVENT_VSTATE([$1],
					m4_dquote(NR_BUMP_VSTATE($2,
						m4_dquote(m4_shift($3)))),
					m4_shift3($@))])])])


dnl  NR_FOR_EACH_EVENT(macro-name, root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_FOR_EACH_EVENT()`, but not bound to any particular
dnl  history (the desired history must be passed explicitly)
dnl
dnl  Requires: `NR_BUMP_VSTATE()`
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
AC_DEFUN([NR_FOR_EACH_EVENT],
	[m4_if([$#], [1], [], [$#], [2], [$2],
		[$1(m4_dquote(NR_BUMP_VSTATE($2, m4_dquote(m4_shift($3)))), $3)[]m4_if([$#], [3], [],
			[NR_FOR_EACH_EVENT([$1],
				m4_dquote(NR_BUMP_VSTATE($2,
					m4_dquote(m4_shift($3)))),
				m4_shift3($@))])])])


dnl  NR_HISTORY_FOR_EACH_EVENT(macro-name)
dnl  **************************************************************************
dnl
dnl  Calls a custom macro for each event in the history, computing its version
dnl
dnl  Requires: `NR_FOR_EACH_EVENT()`
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_HISTORY_FOR_EACH_EVENT],
	[NR_FOR_EACH_EVENT([$1],
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS)])


dnl  NR_VSTATE_GET_PROJECT_VERSION(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Expands to the package version (MAJOR.MINOR.MICRO) of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_PROJECT_VERSION], [m4_incr([$1]).$2.$3])


dnl  NR_VSTATE_GET_PROJECT_MAJVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package major version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_PROJECT_MAJVER], [$1])


dnl  NR_VSTATE_GET_PROJECT_MINVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package minor version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_PROJECT_MINVER], [$2])


dnl  NR_VSTATE_GET_PROJECT_MICVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package micro version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_PROJECT_MICVER], [$3])


dnl  NR_VSTATE_GET_BINARY_VERSION(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Expands to the binary version (MAJOR.MINOR.MICRO) of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_BINARY_VERSION], [$1.$6.$5])


dnl  NR_VSTATE_GET_BINARY_MAJVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary major version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_BINARY_MAJVER],
	[m4_if(m4_eval([$1 > 0]), [1],
		[m4_quote(m4_decr([$1]))], [[0]]))])


dnl  NR_VSTATE_GET_BINARY_MINVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary minor version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_BINARY_MINVER], [$6])


dnl  NR_VSTATE_GET_BINARY_MICVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary micro version number of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_BINARY_MICVER], [$5])


dnl  NR_VSTATE_GET_LIBTOOL_VERSION_INFO(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_LIBTOOL_VERSION_INFO], [$4:$5:$6])


dnl  NR_VSTATE_GET_INTERFACE_NUM(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the interface number of a version state (corresponds to libtool
dnl  version info's `current` field)
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_INTERFACE_NUM], [$4])


dnl  NR_VSTATE_GET_INTERFACES_SUPPORTED(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the number of previous interfaces supported of a version state
dnl  (corresponds to libtool version info's `age` field -- synonym of
dnl  `NR_VSTATE_GET_BINARY_MINVER()`)
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_INTERFACES_SUPPORTED], [$6])


dnl  NR_VSTATE_GET_IMPLEMENTATION_NUM(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the implementation number of a version state (corresponds to
dnl  libtool version info's `revision` field -- synonym of
dnl  `NR_VSTATE_GET_BINARY_MICVER()`)
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_IMPLEMENTATION_NUM], [$5])


dnl  NR_VSTATE_GET_SOURCE_AGE(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the source age of a version state
dnl
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
m4_define([NR_VSTATE_GET_SOURCE_AGE], [$7])


dnl  NC_AUTOVERSION_SUBSTITUTIONS()
dnl  **************************************************************************
dnl
dnl  Export all the version literals as `configure` substitutions
dnl
dnl  Requires: `NR_RECORD_HISTORY()`
dnl  From: not-autotools/m4/not-autoversion.m4
dnl
AC_DEFUN_ONCE([NC_AUTOVERSION_SUBSTITUTIONS], [
	AC_SUBST([PROJECT_VERSION], NR_PROJECT_VERSION)
	AC_SUBST([PROJECT_MAJVER], NR_PROJECT_MAJVER)
	AC_SUBST([PROJECT_MINVER], NR_PROJECT_MINVER)
	AC_SUBST([PROJECT_MICVER], NR_PROJECT_MICVER)
	AC_SUBST([BINARY_VERSION], NR_BINARY_VERSION)
	AC_SUBST([BINARY_MAJVER], NR_BINARY_MAJVER)
	AC_SUBST([BINARY_MINVER], NR_BINARY_MINVER)
	AC_SUBST([BINARY_MICVER], NR_BINARY_MICVER)
	AC_SUBST([LIBTOOL_VERSION_INFO], NR_LIBTOOL_VERSION_INFO)
	AC_SUBST([INTERFACE_NUM], NR_INTERFACE_NUM)
	AC_SUBST([INTERFACES_SUPPORTED], NR_INTERFACES_SUPPORTED)
	AC_SUBST([IMPLEMENTATION_NUM], NR_IMPLEMENTATION_NUM)
	AC_SUBST([SOURCE_AGE], NR_SOURCE_AGE)
	AC_SUBST([HISTORY_CURRENT_EVENT_NAME], NR_HISTORY_CURRENT_EVENT_NAME)
])



dnl  **************************************************************************
dnl  NOTE:  The `NR_` prefix (which stands for "Not autoReconf") and the `NC_`
dnl         prefix (which stands for "Not autoConf") are used with the purpose
dnl         of avoiding collisions with the default Autotools prefixes `AC_`,
dnl         `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

