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
dnl  A U T O V E R S I O N I N G   M A C R O S
dnl  **************************************************************************



dnl  NR_RECORD_HISTORY([root], event1[, event2[, ... eventN]])
dnl  **************************************************************************
dnl
dnl  Automatically assigns version numbers to all the releases of an
dnl  unversioned history declared in a ChangeLog-like style
dnl
dnl  Would you like to stop worrying about the meanings of the changes that
dnl  your release carries, and how these must be translated into different
dnl  versioning schemes (such as semantic versioning, libtool's version info,
dnl  distributions-specific conventions, etc., etc.)?
dnl
dnl  If yes, then you are in the right place.
dnl
dnl  This framework offers a simple way to automatize the versioning process,
dnl  by relying only on a ChangeLog-like list of _unversioned events_, whose
dnl  version is computed automatically and in a reproducible way that depends
dnl  on the nature of the changes.
dnl
dnl  The `n4_has()` macro from `not-m4sugar.m4` is required, so before getting
dnl  started you will need to copy and paste it in your `configure.ac`.
dnl  Furthermore, all the macros from this document will need to be to be
dnl  included too.
dnl
dnl  With this framework, a list of unversioned events is passed to
dnl  `NR_RECORD_HISTORY()` early in `configure.ac` -- possibly before
dnl  `AC_INIT()`.
dnl
dnl  Storing the complete release history will look more or less like the
dnl  following example -- the version numbers in the comments are only for the
dnl  purpose of clarity, as the macro does not require any version numbers for
dnl  its input (it rather _generates_ them):
dnl
dnl      NR_RECORD_HISTORY([[1]],
dnl
dnl          dnl  *************** 1.1.0 (0:0:0) #1 ***************
dnl          [[2018-10-21],
dnl              [HEADERS],
dnl              [MILESTONE]],
dnl
dnl          dnl  *************** 1.1.1 (0:0:0) #1 ***************
dnl          [[2018-10-29],
dnl              [MISCELLANEA]],
dnl
dnl          dnl  *************** 1.1.2 (0:1:0) #1 ***************
dnl          [[2018-11-12],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]],
dnl
dnl          dnl  *************** 1.2.0 (0:2:0) #2 ***************
dnl          [[2018-12-03],
dnl              [IMPLEMENTATION],
dnl              [HEADERS]],
dnl
dnl          dnl  *************** 1.3.0 (1:0:1) #0 ***************
dnl          [[2019-02-14],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]],
dnl
dnl          dnl  *************** 1.4.0 (2:0:2) #0 ***************
dnl          [[2019-03-22],
dnl              [INTERFACE]],
dnl
dnl          dnl  *************** 1.5.0 (3:0:3) #0 ***************
dnl          [[2019-05-07],
dnl              [INTERFACE],
dnl              [IMPLEMENTATION],
dnl              [MISCELLANEA]],
dnl
dnl          dnl  *************** 1.6.0 (3:1:3) #0 ***************
dnl          [[2019-06-10],
dnl              [IMPLEMENTATION],
dnl              [MILESTONE]],
dnl
dnl          dnl  *************** 1.7.0 (3:2:3) #1 ***************
dnl          [[CURRENT],
dnl              [IMPLEMENTATION],
dnl              [HEADERS],
dnl              [MISCELLANEA]])
dnl
dnl  In the simplest scenario, a `configure.ac` script will look like the
dnl  following example:
dnl
dnl      NR_RECORD_HISTORY(...)
dnl
dnl      AC_INIT([Foo Bar],
dnl          NR_PROJECT_VERSION,
dnl          [the.author@example.com],
dnl          [foobar],
dnl          [https://www.example.com])
dnl
dnl      ...
dnl
dnl  And that's it.
dnl
dnl  Before further reading, you can see the example above in action at
dnl  `examples/not-autoversion/simple-example/`.
dnl
dnl  The arguments passed to  `NR_RECORD_HISTORY()` are the `root` version
dnl  (simply `[[1]]` in the example above) -- this parameter will be described
dnl  later in this manual -- and a series of events.
dnl
dnl  An `event` is itself a list, composed of a unique custom name followed by
dnl  one or more changes.
dnl
dnl  A `change` is a registered descriptive token that illustrates the type of
dnl  change that a release carries. A typical `event` looks like the following
dnl  list,
dnl
dnl      [[36ab69c],
dnl          [IMPLEMENTATION],
dnl          [HEADERS],
dnl          [MISCELLANEA]]
dnl
dnl  where `36ab69c` is the event's name (in this case it is a git commit, but
dnl  the field may contain any custom unique string) and `IMPLEMENTATION`,
dnl  `HEADERS` and `MISCELLANEA` are the tokens that best describe the changes
dnl  that have occurred during that release event.
dnl
dnl  Possible tokens for the `change` keywords are:
dnl
dnl      DEPARTURE           If this is a library, the new changes break binary
dnl                          compatibility with the programs that have depended
dnl                          on it so far (if this is the case, you **must** 
dnl                          pick this token). If this is a program, this token
dnl                          describes a major reshape or a change of paradigm.
dnl
dnl      INTERFACE           If this is a library, the way in which the
dnl                          compiled binary interfaces with other programs has
dnl                          changed; if this is a program, the way in which it
dnl                          interfaces with humans has changed. You should not
dnl                          worry about binary compatibility here; if this
dnl                          description meets in some ways the reality of what
dnl                          happened, you should pick this token.
dnl
dnl      HEADERS             This keyword describes source-only additions to
dnl                          a library's public headers (if any) _that did not
dnl                          alter in any way the compiled binary_ (e.g., C
dnl                          macros, typedefs, adding deprecated features
dnl                          etc.). If these exist, pick this token too. If
dnl                          these co-exist with changes in the interface, you
dnl                          may use both tokens.
dnl
dnl      MILESTONE           This keyword describes changes _of any kind_ (in
dnl                          the implementation, the package data, the program
dnl                          functionalities, the documentation, etc.),
dnl                          important enough to be highlighted as milestones.
dnl
dnl      IMPLEMENTATION      This keyword describes internal changes in the
dnl                          compiled binary that did not alter at all the way
dnl                          this interfaces with the rest of the world. If
dnl                          these are present, pick this token.
dnl
dnl      MISCELLANEA         This keyword describes generic changes that did
dnl                          not affect the source code _in any way_ (e.g.,
dnl                          documentation, build system, package data, etc.).
dnl
dnl      LAUNCH              This keyword indicates that the development stage
dnl                          (0.X.X) has ended and the project has entered a
dnl                          mature stage (1.0.0). If we are already in a
dnl                          mature stage, this keyword is no-op.
dnl
dnl      FORK                This keyword indicates that the project has begun
dnl                          a new path as a fork from the previous events. The
dnl                          version state will be reset to [[0]] or [[1]],
dnl                          depending on whether the `LAUNCH` keyword is
dnl                          present as well or not.
dnl
dnl  Each event can contain all possible assortments of the tokens above.
dnl  Unregistered keywords, if found, will be simply ignored.
dnl
dnl      # `Hello world!` and `GUITAR` will be ignored
dnl      [[a94d2aa],
dnl          [IMPLEMENTATION],
dnl          [Hello world!],
dnl          [MISCELLANEA],
dnl          [GUITAR]]
dnl
dnl  The advantage of this approach is that you won't have to worry about
dnl  weird algorithms, such as "increase that number, reset that other", and so
dnl  on; you simply look at the bouquet of available keywords, and if one or
dnl  more keywords describe your changes adequately you just pick them,
dnl  without second thoughts; the framework will do all the calculations for
dnl  you, and these will always be reproducible. As an additional benefit, your
dnl  package will now possess a human-readable (although generic)
dnl  ChangeLog-like release history that can be read by machines too.
dnl
dnl  You will notice during a development stage (0.X.X) that some of the tokens
dnl  behave differently. This is so by design. The only way to exit from a
dnl  development stage is by assigning the `LAUNCH` keyword to one of the
dnl  events in the history, or by starting the history with a `root` argument
dnl  greater than zero.
dnl
dnl  Once you have written down the history, several literals will be exported
dnl  to your `configure.ac` script. The ones that refer to the current version
dnl  (i.e. the latest event in the history) are:
dnl
dnl  * `NR_PROJECT_MAJVER`
dnl  * `NR_PROJECT_MINVER`
dnl  * `NR_PROJECT_MICVER`
dnl  * `NR_BINARY_MAJVER`
dnl  * `NR_BINARY_MINVER`
dnl  * `NR_BINARY_MICVER`
dnl  * `NR_INTERFACE_NUM`
dnl  * `NR_INTERFACES_SUPPORTED`
dnl  * `NR_IMPLEMENTATION_NUM`
dnl  * `NR_SOURCE_AGE`
dnl  * `NR_PROJECT_VERSION`
dnl  * `NR_BINARY_VERSION`
dnl  * `NR_LIBTOOL_VERSION_INFO`
dnl  * `NR_HISTORY_CURRENT_EVENT_NAME`
dnl  * `NR_HISTORY_CURRENT_VSTATE`
dnl  * `NR_HISTORY_ROOT_VSTATE`
dnl
dnl  A project's documentation is not versioned by this framework (hence why
dnl  the generic `MISCELLANEA` token must be used for referring to it), as
dnl  there are no known mechanical rules for versioning a documentation.
dnl
dnl  The first ten macros expand to positive integers. In particular,
dnl
dnl  * `NR_PROJECT_MAJVER`, `NR_PROJECT_MINVER` and `NR_PROJECT_MICVER`
dnl    cumulatively apply semantic versioning to the entire project (these
dnl    numbers construct your main version string `NR_PROJECT_VERSION`)
dnl  * `NR_BINARY_MAJVER`, `NR_BINARY_MINVER`, `NR_BINARY_MICVER`, apply
dnl    something similar to semantic versioning to the compiled binary only
dnl    (detached from the package), whith the difference that during a
dnl    development stage (0.X.X) these will remain always zero (which is why a
dnl    binary version starting with zero does not indicate a development stage)
dnl    -- these build your binary version string `NR_BINARY_VERSION`)
dnl  * `NR_INTERFACE_NUM`, `NR_INTERFACES_SUPPORTED` and
dnl    `NR_IMPLEMENTATION_NUM`, correspond to libtool version info's `current`,
dnl    `age` and `revision` respectively (see `NR_LIBTOOL_VERSION_INFO` for the
dnl    entire string) -- during a development stage (0.X.X) these will remain
dnl    always zero
dnl  * `NR_SOURCE_AGE` counts the header-only changes since the last interface
dnl    was released
dnl
dnl  Moreover, the `NR_HISTORY_CURRENT_EVENT_NAME` macro expands to the name of
dnl  the latest release event (typically `CURRENT`), while
dnl  `NR_HISTORY_CURRENT_VSTATE` and `NR_HISTORY_ROOT_VSTATE`
dnl  contain the earliest and the latest version states available.
dnl
dnl  NOTE:  If your package installs different independent libraries, using the
dnl         `NR_LIBTOOL_VERSION_INFO` literal might become problematic. You
dnl         will have to choose whether using the same version info for all
dnl         your libraries (in this case you can use `NR_LIBTOOL_VERSION_INFO`
dnl         for it), or versioning each module differently by hand (and in this
dnl         case you will have to either ignore `NR_LIBTOOL_VERSION_INFO`, or
dnl         use it only for a module that you consider to be the main module of
dnl         the package). The `NR_BINARY_VERSION` literal instead will never be
dnl         affected by the presence of independent modules, as this literal
dnl         always refers collectively to all the binaries shipped by your
dnl         package (i.e. it is never the version of one single module, but of
dnl         the entire set of binaries that your package generates altogether).
dnl         The changes that you write in your history must in any case refer
dnl         to the entire package as a whole.
dnl
dnl  If used in conjunction with `NC_CONFIG_SHADOW_DIR()` (see
dnl  `m4/not-extended-config.m4`), this framework literally makes it possible
dnl  continuously to publish releases _without ever having to write a single
dnl  version number by hand_, not even once; `NC_CONFIG_SHADOW_DIR()` and
dnl  `NR_RECORD_HISTORY()` can do that for you and apply the changes to the
dnl  entire package tree. You can see a minimal example if this symbiosis in
dnl  action under `examples/not-autoversion/extended-example/`.
dnl
dnl  Since `NR_RECORD_HISTORY()` is normally invoked before `AC_INIT()`, no
dnl  `configure` substitutions are automatically generated. It is possible
dnl  however to export all the literals above as `configure` substitutions by
dnl  calling the `NC_AUTOVERSION_SUBSTITUTIONS` macro **after** `AC_INIT()` has
dnl  finally been invoked:
dnl
dnl      NR_RECORD_HISTORY(...)
dnl      AC_INIT(...)
dnl      ...
dnl      NC_AUTOVERSION_SUBSTITUTIONS
dnl      ...
dnl      AC_OUTPUT
dnl
dnl  The substitutions will have names identical to their M4 counterparts, but
dnl  will not have the `NR_` prefix -- more or less like the `AC_PACKAGE_NAME`
dnl  literal produces a `PACKAGE_NAME` `configure` substitution, without the
dnl  `AC_` prefix. For example, `NR_PROJECT_MAJVER`'s substitution will be
dnl  named `PROJECT_MAJVER`.
dnl
dnl  If you don't need the whole group of literals, you can manually pick up
dnl  only the literals that you need instead of invoking
dnl  `NC_AUTOVERSION_SUBSTITUTIONS`, thus creating a smaller set of targeted
dnl  substitutions:
dnl
dnl
dnl      NR_RECORD_HISTORY(...)
dnl      AC_INIT(...)
dnl      ...
dnl      AC_SUBST([PROJECT_MAJVER], NR_PROJECT_MAJVER)
dnl      AC_SUBST([PROJECT_MINVER], NR_PROJECT_MINVER)
dnl      AC_SUBST([PROJECT_MICVER], NR_PROJECT_MICVER)
dnl      ...
dnl      # etc.
dnl      ...
dnl      AC_OUTPUT
dnl
dnl  To bootstrap the history from an initial state different than 0.0.0
dnl  (0:0:0) #0 ("SEMVER (LIBTOOL) #SOURCE_AGE") you can pass a comma-separated
dnl  list of (up to) seven positive numbers as the `root` argument. The
dnl  expected fields are: project-major[, project-minor[, project-micro[,
dnl  current[, revision[, age[, source-age]]]]].
dnl
dnl  For instance, to use `1` as the initial major version and `6` as the
dnl  initial minor version, use
dnl
dnl      NR_RECORD_HISTORY([[1], [6]],
dnl          [[2018-10-21],
dnl              [HEADERS],
dnl              [MILESTONE]],
dnl          [...])
dnl
dnl  To obtain the version state of a past event knowing its name the
dnl  `NR_HISTORY_GET_EVENT_VSTATE()` macro is made available. This macro
dnl  becomes useful when the history has grown too big and you want to archive
dnl  a part of it out of your `configure.ac` -- although, unless this has grown
dnl  really gigantic, consider always keeping the history whole and simply
dnl  using a separate file for it, included in `configure.ac` via
dnl  `m4_include()`.
dnl
dnl  For example, imagine you want to archive the history up until an event
dnl  named `ccb21a3`; you would simply add to your `configure.ac`, temporarily,
dnl
dnl      AC_MSG_NOTICE([NR_HISTORY_GET_EVENT_VSTATE([ccb21a3])])
dnl
dnl  which would print something like,
dnl
dnl      configure: 1, 13, 0, 3, 1, 3, 0
dnl
dnl  then you would remove the history until `ccb21a3` (included) and use the
dnl  seven numbers above as the root argument for the new shorter history. The
dnl  removed part can be preserved as a separate inert file.
dnl
dnl      NR_RECORD_HISTORY([[1], [13], [0], [3], [1], [3], [0]],
dnl          [[f82ca90],
dnl              [INTERFACE],
dnl              [...]])
dnl
dnl  Finally, to deal with pre-releases, you simply add your pre-release suffix
dnl  to `AC_INIT()` by hand. This is the best way to deal with something that
dnl  is never going to become part of the history:
dnl
dnl      AC_INIT([Foo Bar],
dnl          NR_PROJECT_VERSION[.alpha],
dnl          [the.author@example.com],
dnl          [foobar],
dnl          [https://www.example.com])
dnl
dnl  This macro may -- and should -- be invoked before `AC_INIT()`.
dnl
dnl  NOTE:  Since this framework deals only with upstream changes, it runs
dnl         entirely at `autoreconf` time (not at `configure` time); there will
dnl         be no traces of it in the `configure` script generated, except for
dnl         the literals computed. It goes without saying that you cannot use
dnl         shell expansions here, you must use only literals.
dnl
dnl  Expansion type: literal (void)
dnl  Requires: `NR_BUMP_VSTATE()`, `NR_GET_EVENT_VSTATE()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
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
dnl
dnl  NR_HISTORY_GET_EVENT_VSTATE([event-name])
dnl  **************************************************************************
dnl
dnl  Get the version of a particular event in the release history by using its
dnl  name -- defaults to `NR_HISTORY_CURRENT_VSTATE` when no event is
dnl  found
dnl
dnl  The returned text is a comma-separated list of numbers, representing
dnl  respecively major, minor, micro, current, revision, age, source-age.
dnl
dnl  To extract a particular value from it, you can pass the returned list as
dnl  as arguments to any of the following macros:
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
dnl  **************************************************************************
m4_define([NR_HISTORY_GET_EVENT_VSTATE],
	[NR_GET_EVENT_VSTATE(]m4_dquote([$][1])[,
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS)])dnl
dnl
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
dnl  The project's major version number -- equal to `NR_BINARY_MAJVER` + 1
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
dnl  The binary's major version number -- equal to `NR_PROJECT_MAJVER` - 1
m4_define([NR_BINARY_MAJVER],
	m4_if(m4_eval(NR_PROJECT_MAJVER[ > 0]), [1],
		[m4_quote(m4_decr(NR_PROJECT_MAJVER))], [[0]]))dnl
dnl
dnl
dnl  NR_BINARY_MINVER()
dnl  **************************************************************************
dnl  The binary's minor version number -- synonym of `NR_INTERFACES_SUPPORTED`
m4_define([NR_BINARY_MINVER],
	m4_quote(m4_argn([6], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_BINARY_MICVER()
dnl  **************************************************************************
dnl  The binary's micro version number -- synonym of `NR_IMPLEMENTATION_NUM`
m4_define([NR_BINARY_MICVER],
	m4_quote(m4_argn([5], NR_HISTORY_CURRENT_VSTATE)))dnl
dnl
dnl
dnl  NR_BINARY_VERSION()
dnl  **************************************************************************
dnl  The binary's version string
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
dnl                 revision, age, source-age, change-list)
dnl  **************************************************************************
dnl
dnl  Applies one or more changes to a version state
dnl
dnl  This macro is mainly intended to be used internally by
dnl  `NR_RECORD_HISTORY()`; you will hardly ever need it. For the definition of
dnl  a `change`, please refer to `NR_RECORD_HISTORY()`.
dnl
dnl  The `change-list` argument corresponds to an `event` without its first
dnl  member (i.e. without the event's name).
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `n4_has()` from `not-m4sugar.m4`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
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


dnl  NR_GET_EVENT_VSTATE(event-name, root-vstate, event1[, event2[, ...
dnl                      eventN]])
dnl  **************************************************************************
dnl
dnl  Similar to `NR_HISTORY_GET_EVENT_VSTATE()`, but not bound to any
dnl  particular history (the desired history must be passed explicitly)
dnl
dnl  This macro is mainly intended to be used internally by
dnl  `NR_RECORD_HISTORY()`; you will hardly ever need it.
dnl
dnl  For example, the following code
dnl
dnl      NR_GET_EVENT_VSTATE([1989-04-28],
dnl
dnl          [[0], [0], [0], [0], [0], [0], [0]],
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
dnl      0, 0, 2, 0, 1, 0, 0
dnl
dnl  The difference between `root-vstate` and `NR_RECORD_HISTORY()`'s `root`
dnl  argument is that the former must always contain exactly seven integers.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_BUMP_VSTATE()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
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
dnl  This macro is mainly intended to be used internally by
dnl  `NR_HISTORY_FOR_EACH_EVENT()`; you will hardly ever need it.
dnl
dnl  For example, the following code
dnl
dnl      # Requires: `n4_let()` from `not-m4sugar.m4`
dnl      AC_DEFUN([PRINT_RELEASE], [
dnl      [##] NR_VSTATE_GET_PROJECT_VERSION($1) ($2)
dnl
dnl      - n4_let([DEPARTURE],
dnl              [**Major version bump** - this release is binary-incompatible with previous[]m4_newline()  releases!],
dnl          [INTERFACE],
dnl              [The interface has changed],
dnl          [HEADERS],
dnl              [The public headers have changed],
dnl          [MILESTONE],
dnl              [One or more milestones have been reached],
dnl          [IMPLEMENTATION],
dnl              [The implementation has been improved],
dnl          [MISCELLANEA],
dnl              [Minor changes in the package],
dnl
dnl          [m4_join(m4_newline()[- ], m4_unquote(m4_shift2($@)))])
dnl      ])
dnl
dnl      cat << 'END_HEREDOC'
dnl      NR_FOR_EACH_EVENT([PRINT_RELEASE],
dnl
dnl          [[1], [0], [0], [0], [0], [0], [0]],
dnl
dnl          [[2018-10-21], [HEADERS], [MILESTONE]],
dnl          [[2018-10-29], [MISCELLANEA]],
dnl          [[2018-11-12], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2018-12-03], [IMPLEMENTATION], [HEADERS]],
dnl          [[2019-02-14], [INTERFACE], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2019-03-22], [INTERFACE]],
dnl          [[2019-05-07], [INTERFACE], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2019-06-10], [IMPLEMENTATION], [MILESTONE]],
dnl          [[2020-01-11], [DEPARTURE]])
dnl      END_HEREDOC
dnl
dnl  will print
dnl
dnl      ## 1.1.0 (2018-10-21)
dnl
dnl      - The public headers have changed
dnl      - One or more milestones have been reached
dnl
dnl      ## 1.1.1 (2018-10-29)
dnl
dnl      - Minor changes in the package
dnl
dnl      ## 1.1.2 (2018-11-12)
dnl
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.2.0 (2018-12-03)
dnl
dnl      - The implementation has been improved
dnl      - The public headers have changed
dnl
dnl      ## 1.3.0 (2019-02-14)
dnl
dnl      - The interface has changed
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.4.0 (2019-03-22)
dnl
dnl      - The interface has changed
dnl
dnl      ## 1.5.0 (2019-05-07)
dnl
dnl      - The interface has changed
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.6.0 (2019-06-10)
dnl
dnl      - The implementation has been improved
dnl      - One or more milestones have been reached
dnl
dnl      ## 2.0.0 (2020-01-11)
dnl
dnl      - **Major version bump** - this release is binary-incompatible with previous
dnl        releases!
dnl
dnl  The difference between `root-vstate` and `NR_RECORD_HISTORY()`'s `root`
dnl  argument is that the former must always contain exactly seven integers.
dnl
dnl  The custom macro `macro-name` is invoked with the release version as first
dnl  argument, the release name as second argument, and a variable number of
dnl  change tokens as variadic arguments.
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_BUMP_VSTATE()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
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
dnl  For example, the following code
dnl
dnl      NR_RECORD_HISTORY([[1]],
dnl          [[2018-10-21], [HEADERS], [MILESTONE]],
dnl          [[2018-10-29], [MISCELLANEA]],
dnl          [[2018-11-12], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2018-12-03], [IMPLEMENTATION], [HEADERS]],
dnl          [[2019-02-14], [INTERFACE], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2019-03-22], [INTERFACE]],
dnl          [[2019-05-07], [INTERFACE], [IMPLEMENTATION], [MISCELLANEA]],
dnl          [[2019-06-10], [IMPLEMENTATION], [MILESTONE]],
dnl          [[2020-01-11], [DEPARTURE]])
dnl
dnl      # Requires: `n4_let()` from `not-m4sugar.m4`
dnl      AC_DEFUN([PRINT_RELEASE], [
dnl      [##] NR_VSTATE_GET_PROJECT_VERSION($1) ($2)
dnl
dnl      - n4_let([DEPARTURE],
dnl              [**Major version bump** - this release is binary-incompatible with previous[]m4_newline()  releases!],
dnl          [INTERFACE],
dnl              [The interface has changed],
dnl          [HEADERS],
dnl              [The public headers have changed],
dnl          [MILESTONE],
dnl              [One or more milestones have been reached],
dnl          [IMPLEMENTATION],
dnl              [The implementation has been improved],
dnl          [MISCELLANEA],
dnl              [Minor changes in the package],
dnl
dnl          [m4_join(m4_newline()[- ], m4_unquote(m4_shift2($@)))])
dnl      ])
dnl
dnl      cat << 'END_HEREDOC'
dnl      NR_HISTORY_FOR_EACH_EVENT([PRINT_RELEASE])
dnl      END_HEREDOC
dnl
dnl  will print
dnl
dnl      ## 1.1.0 (2018-10-21)
dnl
dnl      - The public headers have changed
dnl      - One or more milestones have been reached
dnl
dnl      ## 1.1.1 (2018-10-29)
dnl
dnl      - Minor changes in the package
dnl
dnl      ## 1.1.2 (2018-11-12)
dnl
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.2.0 (2018-12-03)
dnl
dnl      - The implementation has been improved
dnl      - The public headers have changed
dnl
dnl      ## 1.3.0 (2019-02-14)
dnl
dnl      - The interface has changed
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.4.0 (2019-03-22)
dnl
dnl      - The interface has changed
dnl
dnl      ## 1.5.0 (2019-05-07)
dnl
dnl      - The interface has changed
dnl      - The implementation has been improved
dnl      - Minor changes in the package
dnl
dnl      ## 1.6.0 (2019-06-10)
dnl
dnl      - The implementation has been improved
dnl      - One or more milestones have been reached
dnl
dnl      ## 2.0.0 (2020-01-11)
dnl
dnl      - **Major version bump** - this release is binary-incompatible with previous
dnl        releases!
dnl
dnl  The custom macro `macro-name` is invoked with the release version as first
dnl  argument, the release name as second argument, and a variable number of
dnl  change tokens as variadic arguments.
dnl
dnl  This macro may be invoked before `AC_INIT()`, but only after having
dnl  invoked `NR_RECORD_HISTORY()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_FOR_EACH_EVENT()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_HISTORY_FOR_EACH_EVENT],
	[NR_FOR_EACH_EVENT([$1],
		m4_dquote(NR_HISTORY_ROOT_VSTATE),
		NR_HISTORY_EVENTS)])


dnl  NR_VSTATE_GET_PROJECT_VERSION(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Expands to the package version (MAJOR.MINOR.MICRO) of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_PROJECT_VERSION(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  NOTE:  For the latest version you can directly use `AC_PACKAGE_VERSION`
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_PROJECT_VERSION], [m4_incr([$1]).$2.$3])


dnl  NR_VSTATE_GET_PROJECT_MAJVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package major version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_PROJECT_MAJVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_PROJECT_MAJVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_PROJECT_MAJVER], [$1])


dnl  NR_VSTATE_GET_PROJECT_MINVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package minor version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_PROJECT_MINVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_PROJECT_MINVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_PROJECT_MINVER], [$2])


dnl  NR_VSTATE_GET_PROJECT_MICVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the package micro version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_PROJECT_MICVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_PROJECT_MICVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_PROJECT_MICVER], [$3])


dnl  NR_VSTATE_GET_BINARY_VERSION(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Expands to the binary version (MAJOR.MINOR.MICRO) of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_BINARY_VERSION(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_BINARY_VERSION], [$1.$6.$5])


dnl  NR_VSTATE_GET_BINARY_MAJVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary major version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_BINARY_MAJVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_BINARY_MAJVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_BINARY_MAJVER],
	[m4_if(m4_eval([$1 > 0]), [1],
		[m4_quote(m4_decr([$1]))], [[0]]))])


dnl  NR_VSTATE_GET_BINARY_MINVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary minor version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_BINARY_MINVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_BINARY_MINVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_BINARY_MINVER], [$6])


dnl  NR_VSTATE_GET_BINARY_MICVER(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the binary micro version number of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_BINARY_MICVER(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_BINARY_MICVER`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_BINARY_MICVER], [$5])


dnl  NR_VSTATE_GET_LIBTOOL_VERSION_INFO(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Expands to the libtool version info (CURRENT:REVISION:AGE) of a version
dnl  state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_LIBTOOL_VERSION_INFO(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_LIBTOOL_VERSION_INFO], [$4:$5:$6])


dnl  NR_VSTATE_GET_INTERFACE_NUM(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the interface number of a version state (corresponds to libtool
dnl  version info's `current` field)
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_INTERFACE_NUM(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_INTERFACE_NUM`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_INTERFACE_NUM], [$4])


dnl  NR_VSTATE_GET_INTERFACES_SUPPORTED(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the number of previous interfaces supported of a version state
dnl  (corresponds to libtool version info's `age` field -- synonym of
dnl  `NR_VSTATE_GET_BINARY_MINVER()`)
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_INTERFACES_SUPPORTED(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use
dnl         `NR_INTERFACES_SUPPORTED`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_INTERFACES_SUPPORTED], [$6])


dnl  NR_VSTATE_GET_IMPLEMENTATION_NUM(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the implementation number of a version state (corresponds to
dnl  libtool version info's `revision` field -- synonym of
dnl  `NR_VSTATE_GET_BINARY_MICVER()`)
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_IMPLEMENTATION_NUM(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_IMPLEMENTATION_NUM`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_IMPLEMENTATION_NUM], [$5])


dnl  NR_VSTATE_GET_SOURCE_AGE(project-major, ... source-age)
dnl  **************************************************************************
dnl
dnl  Retrieves the source age of a version state
dnl
dnl  Example:
dnl
dnl      NR_VSTATE_GET_SOURCE_AGE(NR_HISTORY_CURRENT_VSTATE)
dnl
dnl  NOTE:  For the latest version you can directly use `NR_SOURCE_AGE`
dnl
dnl  This macro may be invoked before `AC_INIT()`.
dnl
dnl  Expansion type: literal
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
m4_define([NR_VSTATE_GET_SOURCE_AGE], [$7])


dnl  NC_AUTOVERSION_SUBSTITUTIONS()
dnl  **************************************************************************
dnl
dnl  Export all the version literals as `configure` substitutions
dnl
dnl  This macro may be invoked only after having invoked both `AC_INIT()` and
dnl  `NR_RECORD_HISTORY()`.
dnl
dnl  Expansion type: literal
dnl  Requires: `NR_RECORD_HISTORY()`
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
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

