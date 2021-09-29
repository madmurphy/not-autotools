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


dnl  n4_case_in(text, list1, if-found1[, ... listN, if-foundN], [if-not-found])
dnl  **************************************************************************
dnl
dnl  Searches for the first occurrence of `text` in each comma-separated list
dnl  `listN`
dnl
dnl  From: not-autotools/m4/not-m4sugar.m4
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


dnl  NC_CONFIG_SHADOW_DIR(subdir)
dnl  **************************************************************************
dnl
dnl  Creates an extended configuration mode for files that rarely need to be
dnl  re-configured
dnl
dnl  Requires: `n4_case_in()`
dnl  From: not-autotools/m4/not-extended-config.m4
dnl
AC_DEFUN_ONCE([NC_CONFIG_SHADOW_DIR], [dnl
AC_REQUIRE([AC_PROG_LN_S])
m4_define([NC_SHADOW_DIR], [$1])
m4_define([NC_CONFNEW_SUBDIR], [confnew])
m4_define([NC_THREATENED_LIST], [])
AC_SUBST([confnewdir], [']NC_CONFNEW_SUBDIR['])
AC_ARG_ENABLE([extended-config],
	[AS_HELP_STRING([--enable-extended-config@<:@=MODE@:>@],
		[extend the configure process to files that normally do not need
		to be re-configured, as their final content depends on upstream
		changes only and not on the state of this machine; possible values
		for MODE are: omitted or "yes" or "merge" for updating these files
		immediately, "sandbox" for safely putting their updated version
		into the `]m4_quote(NC_CONFNEW_SUBDIR)[` directory without modifying
		the package tree, or "no" for doing nothing @<:@default=no@:>@])],
		[AS_IF([test "x${enableval}" = x -o "x${enableval}" = xyes],
				[AS_VAR_SET([enable_extended_config], ['merge'])],
			[test "x${enableval}" != xsandbox -a "x${enableval}" != xmerge], [
				AS_VAR_SET([enable_extended_config], ['no'])
				AC_MSG_WARN([unrecognized option: --enable-extended-config='${enableval}'])
			])],
		[AS_VAR_SET([enable_extended_config], ['no'])])
AM_CONDITIONAL([HAVE_EXTENDED_CONFIG], [test "x${enable_extended_config}" != xno])
AM_CONDITIONAL([HAVE_UPDATES], [test "x${enable_extended_config}" = xsandbox])
AM_COND_IF([HAVE_EXTENDED_CONFIG], [
	AS_MKDIR_P(["]m4_quote(NC_CONFNEW_SUBDIR)["])
	AC_CONFIG_COMMANDS([extended-config], [
		AS_IF([test "x${extconfmode}" = xmerge], [
			AS_VAR_SET([abs_srcdir], ["$(cd "${srcdir}" && pwd)"])
			echo "${threatlist}" | while read -r _FILE_; do
				mv "NC_CONFNEW_SUBDIR/${_FILE_}" "${srcdir}/${_FILE_}" && \
				(cd "$(dirname "NC_CONFNEW_SUBDIR/${_FILE_}")" && \
				${LN_S} "${abs_srcdir}/${_FILE_}" "$(basename "NC_CONFNEW_SUBDIR/${_FILE_}")")
			done
			AC_MSG_NOTICE([extended configuration has been merged with the package tree.])
			AS_UNSET([abs_srcdir])
		], [
			AC_MSG_NOTICE([extended configuration has been saved in ./NC_CONFNEW_SUBDIR.])
		])
		AS_UNSET([threatlist])
		AS_UNSET([extconfmode])
	], [
		AS_VAR_SET([extconfmode], ['${enable_extended_config}'])
		AS_VAR_SET([threatlist], ['${nc_threatlist}'])
	])
])dnl
dnl
dnl  NC_THREATEN_FILES(file1[, file2[, file3[, ... fileN]]])
dnl  **************************************************************************
dnl  For the documentation, see `NC_CONFIG_SHADOW_DIR()`
AC_DEFUN([NC_THREATEN_FILES], [
	AM_COND_IF([HAVE_EXTENDED_CONFIG], [
		AC_CONFIG_FILES(m4_foreach([_F_ITER_], m4_dquote(]m4_dquote(m4_map_args_sep([m4_normalize(], [)], [,], ][$][@][))[),
			[m4_ifnblank(m4_quote(_F_ITER_),
				[n4_case_in(m4_quote(_F_ITER_), m4_quote(NC_THREATENED_LIST),
					[n4_case_in(m4_quote(_F_ITER_), m4_dquote(NC_SHADOW_REDEF), [],
						[m4_define([NC_SHADOW_REDEF],
							m4_ifset([NC_SHADOW_REDEF],
								[m4_dquote(NC_SHADOW_REDEF,[ ]_F_ITER_)],
								[m4_dquote(_F_ITER_)]))])],
					[m4_define([NC_THREATENED_LIST],
						m4_ifset([NC_THREATENED_LIST],
								[m4_dquote(NC_THREATENED_LIST, _F_ITER_)],
								[m4_dquote(_F_ITER_)]))
					m4_quote(NC_CONFNEW_SUBDIR[/]_F_ITER_[:]NC_SHADOW_DIR[/]_F_ITER_[.in])])])]))
	])
	AS_VAR_SET([nc_threatlist], ["]m4_join(m4_newline(), NC_THREATENED_LIST)["])
	m4_ifdef([NC_SHADOW_REDEF],
		[m4_warn([syntax], [redefined threatened files ]m4_quote(NC_SHADOW_REDEF)[ - skip])])
])dnl
dnl
dnl  NR_THREATEN_BLINDLY()
dnl  **************************************************************************
dnl  dnl  For the documentation, see `NC_CONFIG_SHADOW_DIR()`
AC_DEFUN_ONCE([NR_THREATEN_BLINDLY],
	[NC_THREATEN_FILES(m4_shift(m4_bpatsubst(m4_quote(m4_esyscmd([find ']m4_quote(NC_SHADOW_DIR)[' -type f -name '*.in' -printf ", [[%P{/@/}]]"])), [\.in{/@/}], [])))])dnl
dnl
dnl  NC_SHADOW_AFTER_OUTPUT[(if-merge-cmds[, if-sandbox-cmds])]
dnl  **************************************************************************
dnl
dnl  Example:
dnl
dnl     NC_SHADOW_AFTER_OUTPUT([
dnl        AC_MSG_NOTICE([updating the source code with `${ac_make} all-official-sources`...])
dnl        "${ac_make}" all-official-sources
dnl     ])
dnl
dnl  **************************************************************************
AC_DEFUN_ONCE([NC_SHADOW_AFTER_OUTPUT],
	[m4_ifset([NC_THREATENED_LIST],
		[m4_ifnblank(m4_quote(]m4_dquote(][$][1][$][2][)[),
			[AM_COND_IF([HAVE_UPDATES],
				m4_ifblank(m4_quote(]m4_dquote(]m4_dquote(][$][2][)[)[),
					[[:]],
					[[m4_expand(m4_argn([2],
						]m4_dquote(]m4_dquote(]m4_dquote(]m4_dquote(][$][@][)[)[)[)[))]])[]m4_ifnblank(m4_quote(]m4_dquote(]m4_dquote(][$][1][)[)[), [,
						[AM_COND_IF([HAVE_EXTENDED_CONFIG],
							[m4_expand(m4_argn([1],
								]m4_dquote(]m4_dquote(]m4_dquote(]m4_dquote(]m4_dquote(][$][@][)[)[)[)[)[))])]]))])],
		[m4_warn([syntax], [NC_CONFIG_SHADOW_DIR has been invoked but no files have been threatened.])])])dnl
])


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
		m4_default_nblank_quoted(m4_argn([2], $1), [0]),
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
					[0, 0, 0, 0, 0, 0, 0])],
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

