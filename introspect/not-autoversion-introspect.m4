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
dnl  A U T O V E R S I O N I N G   M A C R O S   ( D I A G N O S T I C S )
dnl  **************************************************************************


dnl  **************************************************************************
dnl  NOTE:  This document contains debug facilities for `not-autoversion.m4`.
dnl         Normally you don't need to keep these in your `configure.ac`, and
dnl         this is why they have been placed in a separate file. For accessing
dnl         them both this file and `not-autoversion.m4` need to be included.
dnl         The macros of major interest are `NR_HISTORY_GET_VERSION_VSTATE()`
dnl         and `NR_HISTORY_GET_VERSION_EVENT_NAME()`, which both take a
dnl         version as argument and expand to the name and the full `VSTATE` of
dnl         the event that generated that version.
dnl  **************************************************************************



dnl  NR_GET_VERSION_REPORT(project-major, project-minor, project-micro,
dnl                        root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Generate a report about a particular version in an unversioned history
dnl
dnl  This macro is mainly intended to be used internally by other macros; you
dnl  will hardly ever need it.
dnl
dnl  For example, the following code
dnl
dnl      NR_GET_VERSION_REPORT([0], [1], [2],
dnl
dnl          [[0], [1], [0], [0], [0], [0], [0]],
dnl
dnl          [[1987-11-02],
dnl              [MISCELLANEA]],
dnl          [[1989-04-28],
dnl              [IMPLEMENTATION]],
dnl          [[1991-08-13],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]])
dnl
dnl  expands to
dnl
dnl      [0,1,2,0,0,0,0], [1989-04-28], [IMPLEMENTATION]
dnl
dnl  The difference between `root-vstate` and `NR_RECORD_HISTORY()`'s `root`
dnl  argument is that the former must always contain exactly seven integers.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_BUMP_VSTATE()` from `not-autoversion.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_GET_VERSION_REPORT],
	[m4_pushdef([__iter__],
		m4_quote(NR_BUMP_VSTATE($4, m4_dquote(m4_shift($5)))))[]m4_if([$#], [0], [],
		[$#], [1], [], [$#], [2], [], [$#], [3], [], [$#], [4], [], 
			[m4_if(m4_eval([$1 > ]m4_argn(1, __iter__)), [1],
					[m4_if([$#], [5],
						[m4_popdef([__iter__])],
						[NR_GET_VERSION_REPORT([$1], [$2], [$3],
							m4_dquote(__iter__)[]m4_popdef([__iter__]),
							m4_shiftn(5, $@))])],
				[$1], m4_argn(1, __iter__),
					[m4_if(m4_eval([$2 > ]m4_argn(2, __iter__)), [1],
							[m4_if([$#], [5],
								[m4_popdef([__iter__])],
								[NR_GET_VERSION_REPORT([$1], [$2], [$3],
									m4_dquote(__iter__)[]m4_popdef([__iter__]),
									m4_shiftn(5, $@))])],
						[$2], m4_argn(2, __iter__),
							[m4_if(m4_eval([$3 > ]m4_argn(3, __iter__)), [1],
									[m4_if([$#], [5],
										[m4_popdef([__iter__])],
										[NR_GET_VERSION_REPORT([$1], [$2], [$3],
											m4_dquote(__iter__)[]m4_popdef([__iter__]),
											m4_shiftn(5, $@))])],
								[$3], m4_argn(3, __iter__),
									[m4_dquote(__iter__)[]m4_popdef([__iter__]), $5],
									[m4_popdef([__iter__])])],
							[m4_popdef([__iter__])])],
					[m4_popdef([__iter__])])])])


dnl  NR_GET_VERSION_EVENT_NAME(project-major, project-minor, project-micro,
dnl                       root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_GET_VERSION_EVENT_NAME()`, but not bound to any
dnl  particular history (the desired history must be passed explicitly, in
dnl  chronological order)
dnl
dnl  This macro is mainly intended to be used internally by
dnl  `NR_HISTORY_GET_VERSION_EVENT_NAME()`; you will hardly ever need it.
dnl
dnl  For example, the following code
dnl
dnl      NR_GET_VERSION_EVENT_NAME([0], [1], [2],
dnl
dnl          [[0], [1], [0], [0], [0], [0], [0]],
dnl
dnl          [[1987-11-02],
dnl              [MISCELLANEA]],
dnl          [[1989-04-28],
dnl              [IMPLEMENTATION]],
dnl          [[1991-08-13],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]])
dnl
dnl  expands to
dnl
dnl      [1989-04-28]
dnl
dnl  The difference between `root-vstate` and `NR_RECORD_HISTORY()`'s `root`
dnl  argument is that the former must always contain exactly seven integers.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_GET_VERSION_EVENT_NAME],
	[m4_argn(2, NR_GET_VERSION_REPORT($@))])


dnl  NR_GET_VERSION_VSTATE(project-major, project-minor, project-micro,
dnl                        root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_GET_VERSION_VSTATE()`, but not bound to any
dnl  particular history (the desired history must be passed explicitly, in
dnl  chronological order)
dnl
dnl  For example, the following code
dnl
dnl      NR_GET_VERSION_VSTATE([0], [1], [2],
dnl
dnl          [[0], [1], [0], [0], [0], [0], [0]],
dnl
dnl          [[1987-11-02],
dnl              [MISCELLANEA]],
dnl          [[1989-04-28],
dnl              [IMPLEMENTATION]],
dnl          [[1991-08-13],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]])
dnl
dnl  expands to
dnl
dnl      [0], [1], [2], [0], [0], [0], [0]
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_GET_VERSION_VSTATE],
	[m4_unquote(m4_argn(1, NR_GET_VERSION_REPORT($@)))])


dnl  NR_GET_VERSION_FULL_EVENT(project-major, project-minor, project-micro,
dnl                            root-vstate, event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_GET_VERSION_FULL_EVENT()`, but not bound to any
dnl  particular history (the desired history must be passed explicitly, in
dnl  chronological order)
dnl
dnl  For example, the following code
dnl
dnl      NR_GET_VERSION_FULL_EVENT([0], [1], [2],
dnl
dnl          [[0], [1], [0], [0], [0], [0], [0]],
dnl
dnl          [[1987-11-02],
dnl              [MISCELLANEA]],
dnl          [[1989-04-28],
dnl              [IMPLEMENTATION]],
dnl          [[1991-08-13],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]])
dnl
dnl  expands to
dnl
dnl      [1989-04-28], [IMPLEMENTATION]
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_GET_VERSION_FULL_EVENT],
	[m4_shift(NR_GET_VERSION_REPORT($@))])


dnl  NR_HISTORY_GET_VERSION_EVENT_NAME(project-major, project-minor,
dnl                                    project-micro)
dnl  **************************************************************************
dnl
dnl  Look up for the event name that generated the version passed as arguments
dnl
dnl  If the version is not found this macro expand to an empty string.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`; `NR_HISTORY_ROOT_VSTATE()` from
dnl            `not-autoversion.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_HISTORY_GET_VERSION_EVENT_NAME],
	[m4_argn(2, NR_GET_VERSION_REPORT([$1], [$2], [$3],
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS))])


dnl  NR_HISTORY_GET_VERSION_VSTATE(project-major, project-minor, project-micro)
dnl  **************************************************************************
dnl
dnl  Look up for the VSTATE that generated the version passed as arguments
dnl
dnl  If the version is found, the returned text is a comma-separated list of
dnl  numbers, representing respecively major, minor, micro, current, revision,
dnl  age, source-age. If the version is not found this macro expand to an empty
dnl  string.
dnl
dnl  To extract a particular value from it, you can pass the returned list as
dnl  arguments to any of the following macros:
dnl
dnl  * `NR_VSTATE_GET_PROJECT_VERSION()`
dnl  * `NR_VSTATE_GET_PROJECT_MAJVER()`
dnl  * `NR_VSTATE_GET_PROJECT_MINVER()`
dnl  * `NR_VSTATE_GET_PROJECT_MICVER()`
dnl  * `NR_VSTATE_GET_BINARY_VERSION()`
dnl  * `NR_VSTATE_GET_BINARY_MAJVER()`
dnl  * `NR_VSTATE_GET_BINARY_MINVER()`
dnl  * `NR_VSTATE_GET_BINARY_MICVER()`
dnl  * `NR_VSTATE_GET_LIBTOOL_VERSION_INFO()`
dnl  * `NR_VSTATE_GET_INTERFACE_NUM()`
dnl  * `NR_VSTATE_GET_INTERFACES_SUPPORTED()`
dnl  * `NR_VSTATE_GET_IMPLEMENTATION_NUM()`
dnl  * `NR_VSTATE_GET_SOURCE_AGE()`
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`; `NR_HISTORY_ROOT_VSTATE()` from
dnl            `not-autoversion.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_HISTORY_GET_VERSION_VSTATE],
	[m4_unquote(m4_argn(1, NR_GET_VERSION_REPORT([$1], [$2], [$3],
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS)))])


dnl  NR_HISTORY_GET_VERSION_FULL_EVENT(project-major, project-minor,
dnl                                    project-micro)
dnl  **************************************************************************
dnl
dnl  Look up for the full event that generated the version passed as arguments
dnl
dnl  If the version is not found this macro expand to an empty string.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_GET_VERSION_REPORT()`; `NR_HISTORY_ROOT_VSTATE()` from
dnl            `not-autoversion.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_HISTORY_GET_VERSION_FULL_EVENT],
	[m4_shift(NR_GET_VERSION_REPORT([$1], [$2], [$3],
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS))])



dnl  **************************************************************************
dnl  NOTE:  The `NR_` prefix (which stands for "Not autoReconf") is used with
dnl         the purpose of avoiding collisions with the default Autotools
dnl         prefixes `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

