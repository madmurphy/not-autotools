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
dnl  E X T E N D E D   C O N F I G U R A T I O N   M O D E
dnl  **************************************************************************



dnl  NC_CONFIG_SHADOW_DIR(subdir)
dnl  **************************************************************************
dnl
dnl  Creates an extended configuration mode for files that rarely need to be
dnl  re-configured
dnl
dnl  A package often contains files that is convenient to build via
dnl  `configure`, but that need to be preserved after launching `make
dnl  distclean` or `make maintainer-clean`, and be re-distributed in their
dnl  configured version (think of a `package.json` file, for example). As these
dnl  files are persistent, they also do not need to be re-created every time a
dnl  user launches `./configure`, but only when the maintainer of the package
dnl  wants to export some important changes (like a version change, for
dnl  example); and as their templates are rarely used, it might be a good idea
dnl  to place these in a separate folder.
dnl
dnl  This macro helps creating the right environment for this purpose. It
dnl  requires `n4_lambda()` and `n4_case_in()` from `not-m4sugar.m4`, so you
dnl  will need to copy and paste them both in your `configure.ac` before
dnl  getting started.
dnl
dnl  When everything is set up, you need to create a subdirectory containing
dnl  the templates of the files that will be rarely re-configured (the `.in`,
dnl  files) and you need to tell `NC_CONFIG_SHADOW_DIR()` about it. A good
dnl  place for invoking `NC_CONFIG_SHADOW_DIR()` is immediately after the
dnl  initialization of the other Autoconf subdirectories, or immediately after
dnl  `AC_INIT()`:
dnl
dnl      AC_INIT([foo], [1.0])
dnl      AC_CONFIG_MACRO_DIR([m4])
dnl      AC_CONFIG_AUX_DIR([build-aux])
dnl      NC_CONFIG_SHADOW_DIR([my_shadows])
dnl
dnl  `NC_CONFIG_SHADOW_DIR()` can be invoked only once. Nested directories are
dnl  supported (e.g., `NC_CONFIG_SHADOW_DIR([maintainer/shadows])`), and if you
dnl  don't want to use a subdirectory but you prefer your rarely-used templates
dnl  to accompany their configured file in the same path, as
dnl  regularly-configured files normally do, you can use `.` for specifying
dnl  that the shadow tree overlaps the package tree:
dnl
dnl      NC_CONFIG_SHADOW_DIR([.])
dnl
dnl  However, as these templates are used only in exceptional circumstances, it
dnl  is preferable to keep them separate from the rest of the package. A common
dnl  idiom states in fact that the files accompanied by their template nearby
dnl  are those that get re-configured every time the `configure` script is run,
dnl  and get erased every time `make maintainer-clean` is invoked. But extended
dnl  configuration behaves differently: files persist and get distributed as
dnl  such, and there is no reason to keep their template in the main tree.
dnl
dnl  Now that the shadow directory has been initialized, you need to list the
dnl  files expected to have a shadow template. The macro `NC_THREATEN_FILES()`
dnl  works similarly to `AC_CONFIG_FILES()`, but with two important
dnl  differences: it requires each file to be listed as a different argument,
dnl  rather than within a space-separated list, and these files are not
dnl  configured every time a user launches `./configure`, but only when the
dnl  latter is launched with an `--enable-extended-config` parameter.
dnl
dnl  A good point of your `configure.ac` where to place `NC_THREATEN_FILES()`
dnl  file is immediately after `AC_CONFIG_FILES()`. But you are free to place
dnl  it anywere between `NC_CONFIG_SHADOW_DIR()` and `NC_SHADOW_MAYBE_OUTPUT`.
dnl
dnl      AC_CONFIG_FILES([
dnl          Makefile
dnl          src/libfoo.pc.in
dnl          src/Makefile
dnl      ])
dnl
dnl      NC_THREATEN_FILES([package.json], [src/winres.rc], [...])
dnl
dnl  The files so registered are now expected to have their template inside the
dnl  directory previously passed to `NC_CONFIG_SHADOW_DIR()` exactly in the
dnl  same relative path, and with a `.in` file extension. So, for instance, the
dnl  template of `src/winres.rc` in the example above is expected to be
dnl  `my_shadows/src/winres.rc.in`.
dnl
dnl  `NC_THREATEN_FILES()` can also be split into different steps:
dnl
dnl      NC_THREATEN_FILES([src/winres.rc])
dnl      [DO SOMETHING ELSE]
dnl      NC_THREATEN_FILES([package.json])
dnl      NC_THREATEN_FILES([...])
dnl
dnl  Alternatively you can use `NC_THREATEN_BLINDLY` for automatically adding
dnl  all the files present in the templates subdirectory. `NC_THREATEN_BLINDLY`
dnl  can be invoked only once and calls `find` during the Automake process (via
dnl  `m4_esyscmd()`), therefore it is less efficient and probably less portable
dnl  than listing each file by hand.
dnl
dnl  No matter whether you use `NC_THREATEN_FILES()` or `NC_THREATEN_BLINDLY`,
dnl  this framework only looks for `.in` files, so theoretically you can use
dnl  the extended configuration subdirectory as a placeholder for other custom
dnl  files (although you probably shouldn't). Moreover, when
dnl  `NC_THREATEN_FILES()` or `NC_THREATEN_BLINDLY` are invoked, the
dnl  "threatened" files are added to `NC_THREATENED_LIST`. The latter is a
dnl  macro that expands to a comma separated array. You can use `m4_foreach()`
dnl  to iterate through it.
dnl
dnl  After having threatened all the files that you needed to threaten, you are
dnl  now free to call `NC_SHADOW_MAYBE_OUTPUT`. Remember that the latter
dnl  **must** follow `AC_OUTPUT`:
dnl
dnl      AC_OUTPUT
dnl      NC_SHADOW_MAYBE_OUTPUT
dnl
dnl  The other way around will not work.
dnl
dnl  In the end, your `configure.ac` will look more or less like this example:
dnl
dnl      AC_INIT([foo], [1.0])
dnl
dnl      ...
dnl
dnl      NC_CONFIG_SHADOW_DIR([my_shadows])
dnl
dnl      ....
dnl
dnl
dnl      AC_CONFIG_FILES([...])
dnl
dnl      NC_THREATEN_FILES([package.json], [src/winres.rc])
dnl
dnl      ...
dnl
dnl      AC_OUTPUT
dnl
dnl      NC_SHADOW_MAYBE_OUTPUT
dnl
dnl  And finally, to add a bit of salt, you should also consider to include
dnl  these two targets in your `Makefile.am`:
dnl      
dnl      clean-local:
dnl          -rm -rf $(CONFNEW_DIR)
dnl
dnl      if HAVE_UPDATES
dnl      
dnl      synch:
dnl          cp -rf $(CONFNEW_DIR)/* ./
dnl      
dnl      endif
dnl
dnl  Here follows the list of all macros, conditionals and `make` variables
dnl  exported after `NC_CONFIG_SHADOW_DIR()` is invoked.
dnl
dnl  Macros exported:
dnl
dnl  - `NC_CONFNEW_DIR`: expands to the path of the sandbox directory
dnl    (currently `confnew`)
dnl  - `NC_SHADOW_DIR`: expands exactly to the argument passed to
dnl    `NC_CONFIG_SHADOW_DIR()`
dnl  - `NC_SHADOW_MAYBE_OUTPUT`: finalizes the extended configuration mode
dnl  - `NC_THREATENED_LIST`: expands to the comma-separated list of the
dnl    threatened files
dnl  - `NC_THREATEN_BLINDLY`: recursively registers all the templates in
dnl    `NC_CONFNEW_DIR` as sources for the extended configuration mode
dnl  - `NC_THREATEN_FILES()`: marks the files passed as arguments as
dnl    "threatened", and expects their template to be in `NC_SHADOW_DIR`
dnl
dnl  Conditionals exported:
dnl
dnl  - `HAVE_EXTENDED_CONFIG`: always `true` when the user invokes `configure`
dnl    with the `--enable-extended-config` option
dnl  - `HAVE_UPDATES`: `true` only in sandbox mode, i.e., when the user invokes
dnl    `configure` with the `--enable-extended-config=sandbox` option
dnl
dnl  `make` variables exported:
dnl
dnl  - `$(CONFNEW_DIR)`: points to the sandbox folder (currently
dnl    `$(srcdir)/confnew`).
dnl
dnl  Expansion type: shell code
dnl  Requires: `n4_lambda()` and `n4_case_in()` from `not-m4sugar.m4`
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN_ONCE([NC_CONFIG_SHADOW_DIR], [

	m4_define([NC_SHADOW_DIR], [$1])
	m4_define([NC_CONFNEW_DIR], [confnew])
	m4_define([NC_THREATENED_LIST], [])
	AC_SUBST([CONFNEW_DIR], ['$(srcdir)/]NC_CONFNEW_DIR['])

	AC_ARG_ENABLE([extended-config],
		[AS_HELP_STRING([--enable-extended-config@<:@=MODE@:>@],
			[extend the configure process to files that normally do not need
			to be re-configured, as their final content depends on upstream
			changes only and not on the state of this machine; possible values
			for MODE are: omitted or "merge" for updating these files
			immediately, "sandbox" for safely putting their updated version
			into the "]NC_CONFNEW_DIR[" subdirectory without modifying the
			package tree, or "no" for doing nothing @<:@default=no@:>@])],
			[AS_IF([test "x${enableval}" = x -o "x${enableval}" = xyes],
					[AS_VAR_SET([enable_extended_config], ['merge'])],
				[test "x${enableval}" != xsandbox -a "x${enableval}" != xmerge], [
					AS_VAR_SET([enable_extended_config], ['no'])
					AC_MSG_WARN([unrecognized option: --enable-extended-config='${enableval}'])
				])],
			[AS_VAR_SET([enable_extended_config], ['no'])])

	AM_CONDITIONAL([HAVE_EXTENDED_CONFIG], [test "x${enable_extended_config}" != xno])
	AM_CONDITIONAL([HAVE_UPDATES], [test "x${enable_extended_config}" = xsandbox])
	AM_COND_IF([HAVE_EXTENDED_CONFIG], [AS_MKDIR_P(NC_CONFNEW_DIR)])

	AC_DEFUN([NC_THREATEN_FILES], [
		AM_COND_IF([HAVE_EXTENDED_CONFIG],
			[AC_CONFIG_FILES([
				]]n4_lambda([n4_case_in(m4_quote(][$][1][), m4_quote(NC_THREATENED_LIST),
					[m4_define([NC_SHADOW_REDEF],
						m4_ifset([NC_SHADOW_REDEF],
							m4_dquote(m4_dquote(NC_SHADOW_REDEF,[ ]]]m4_dquote(m4_dquote([$][1]))[[)),
							m4_dquote(m4_dquote(]]m4_dquote(m4_dquote([$][1]))[[))))],
					[m4_define([NC_THREATENED_LIST],
						m4_ifset([NC_THREATENED_LIST],
							m4_dquote(m4_dquote(NC_THREATENED_LIST, ]]m4_dquote(m4_dquote([$][1]))[[)), m4_dquote(m4_dquote(]]m4_dquote(m4_dquote([$][1]))[[))))NC_CONFNEW_DIR[[/]]]m4_dquote(m4_dquote(][$][1][))[[[:]]NC_SHADOW_DIR[[/]]]m4_dquote(m4_dquote(][$][1][))[[[.in
				]]])m4_if(m4_eval(][$][#][ > 1), [1],
					[n4_anon(m4_shift(]m4_dquote(][$][@][)[))])])(][$][@][)[)
		])
		m4_ifdef([NC_SHADOW_REDEF], [m4_warn([syntax], [redefined configure files ]m4_quote(NC_SHADOW_REDEF)[ - skip])])
	])

	AC_DEFUN_ONCE([NC_THREATEN_BLINDLY],
		[NC_THREATEN_FILES(m4_shift(m4_bpatsubst(m4_quote(m4_esyscmd([find ']NC_SHADOW_DIR[' -type f -name '*.in' -printf ", [[%P{/@/}]]"])), [\.in{/@/}], [])))])

	AC_DEFUN_ONCE([NC_SHADOW_MAYBE_OUTPUT], [
		m4_ifset([NC_THREATENED_LIST], [
			AM_COND_IF([HAVE_UPDATES],
				[AC_MSG_NOTICE([extended configuration has been saved in ./]NC_CONFNEW_DIR[.])],
				[AM_COND_IF([HAVE_EXTENDED_CONFIG], [
					cp -rf NC_CONFNEW_DIR/* ./ && rm -rf NC_CONFNEW_DIR
					AC_MSG_NOTICE([extended configuration has been merged with the package tree.])
				])])
		], [
			m4_warn([syntax], [NC_SHADOW_MAYBE_OUTPUT has been invoked but no files have been threatened.])
		])
	])

])



dnl  **************************************************************************
dnl  Note:  The `NC_` prefix (which stands for "Not autoConf") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF
