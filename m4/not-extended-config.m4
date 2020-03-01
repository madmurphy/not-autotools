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
dnl  E X T E N D E D   C O N F I G U R A T I O N   M O D E
dnl  **************************************************************************



dnl  NC_CONFIG_SHADOW_DIR(subdir)
dnl  **************************************************************************
dnl
dnl  Creates an extended configuration mode for files that rarely need to be
dnl  re-configured
dnl
dnl  A package often contains files that it is convenient to build via
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
dnl  requires `n4_case_in()` from `not-m4sugar.m4`, so you will need to copy
dnl  and paste it in your `configure.ac` before getting started.
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
dnl  Now that the shadow directory has been initialized you need to list the
dnl  files expected to have a shadow template. The macro `NC_THREATEN_FILES()`
dnl  works similarly to `AC_CONFIG_FILES()`, but with two important
dnl  differences: it requires each file to be listed as a different argument,
dnl  rather than within a space-separated list, and these files are not
dnl  configured every time a user launches `./configure`, but only when the
dnl  latter is launched with an `--enable-extended-config` parameter.
dnl
dnl  A good point of your `configure.ac` where to place `NC_THREATEN_FILES()`
dnl  file is immediately after `AC_CONFIG_FILES()`. But you are free to place
dnl  it anywere between `NC_CONFIG_SHADOW_DIR()` and `AC_OUTPUT`.
dnl
dnl      AC_CONFIG_FILES([
dnl          Makefile
dnl          src/libfoo.pc.in
dnl          src/Makefile
dnl      ])
dnl
dnl      NC_THREATEN_FILES(
dnl          [package.json],
dnl          [src/winres.rc],
dnl          [...]
dnl      )
dnl
dnl  The files so indicized are now expected to have their template inside the
dnl  directory previously passed to `NC_CONFIG_SHADOW_DIR()` exactly in the
dnl  same relative path and with a `.in` file extension. So, for instance, the
dnl  template of `src/winres.rc` in the example above is expected to be
dnl  `my_shadows/src/winres.rc.in`.
dnl
dnl  `NC_THREATEN_FILES()` can also be split into different steps:
dnl
dnl      NC_THREATEN_FILES([src/winres.rc])
dnl
dnl      [... DO SOMETHING ELSE ...]
dnl
dnl      NC_THREATEN_FILES([package.json])
dnl
dnl      [...]
dnl
dnl      NC_THREATEN_FILES([...])
dnl
dnl  Alternatively you can use `NC_THREATEN_BLINDLY` for automatically adding
dnl  all the files present in the templates subdirectory. `NC_THREATEN_BLINDLY`
dnl  can be invoked only once and calls `find` during the `autoreconf` process
dnl  (via `m4_esyscmd()`), therefore it is less efficient and probably less
dnl  portable than listing each file by hand.
dnl
dnl  It is not currently supported by design to nest `NC_THREATEN_FILES()`
dnl  or `NC_THREATEN_BLINDLY` within conditionals evaluated at `configure` time
dnl  (such as `AS_IF()` and `AM_COND_IF()`). It is possible, however, to nest
dnl  both macros within M4sugar conditionals (such as `m4_if()`, `m4_ifdef()`,
dnl  `m4_ifset()`, `m4_ifval()`, etc.):
dnl
dnl      m4_define([OFFICIAL_PACKAGE])
dnl
dnl      ...
dnl
dnl      NC_THREATEN_FILES([src/winres.rc])
dnl
dnl      # Perfectly valid example
dnl      m4_ifdef([OFFICIAL_PACKAGE],
dnl          [NC_THREATEN_FILES([package.json])])
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
dnl  After having configured all the files that you needed to configure and
dnl  threatened all the files that you needed to threaten, you are now free to
dnl  call `AC_OUTPUT`.
dnl
dnl      AC_OUTPUT
dnl
dnl  A further optional macro, `NC_SHADOW_AFTER_OUTPUT()`, can be used for
dnl  internal checks or executing additional actions after `AC_OUTPUT` has been
dnl  invoked, but it is not required.
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
dnl  And finally, to add a bit of salt, you should also consider to include
dnl  these two targets in your `Makefile.am`:
dnl      
dnl      distclean-local:
dnl          -rm -rf $(confnewdir)
dnl
dnl      if HAVE_UPDATES
dnl
dnl      .PHONY: mergenew
dnl      mergenew:
dnl          -cp -rf $(confnewdir)/* ./
dnl      
dnl      endif
dnl
dnl  Here follows the list of all macros, conditionals and variables exported
dnl  after `NC_CONFIG_SHADOW_DIR()` is invoked.
dnl
dnl  Macros:
dnl
dnl  - `NC_CONFNEW_SUBDIR`: expands to the path of the sandbox directory
dnl    (currently `confnew`)
dnl  - `NC_SHADOW_DIR`: expands exactly to the argument passed to
dnl    `NC_CONFIG_SHADOW_DIR()`
dnl  - `NC_SHADOW_AFTER_OUTPUT()`: further actions in extended configuration
dnl    mode
dnl  - `NC_THREATENED_LIST`: expands to the comma-separated list of the
dnl    threatened files
dnl  - `NC_THREATEN_BLINDLY`: recursively registers all the templates in
dnl    `NC_CONFNEW_SUBDIR` as sources for the extended configuration mode
dnl  - `NC_THREATEN_FILES()`: marks as "threatened" all the files passed as
dnl    arguments, and expects their template to be in `NC_SHADOW_DIR`
dnl
dnl  `configure` shell variables:
dnl
dnl  - `${enable_extended_config}`: either `no`, `merge` or `sandbox`
dnl    depending on the `--enable-extended-config[=MODE]` argument passed to
dnl    the `configure` script
dnl  - `${confnewdir}`: the sandbox folder (currently `confnew`)
dnl  - `${nc_threatlist}`: like the `NC_THREATENED_LIST` macro, but each file
dnl    is separated by a new line character instead of a comma
dnl
dnl  Automake conditionals:
dnl
dnl  - `HAVE_EXTENDED_CONFIG`: always `true` when the user invokes `configure`
dnl    with the `--enable-extended-config` option
dnl  - `HAVE_UPDATES`: `true` only in sandbox mode, i.e., when the user invokes
dnl    `configure` with the `--enable-extended-config=sandbox` option
dnl
dnl  `Makefile` variables:
dnl
dnl  - `$(confnewdir)`: the sandbox folder (currently `confnew`)
dnl
dnl  Expansion type: shell code
dnl  Requires: `n4_case_in()` from `not-m4sugar.m4`
dnl  Version: 1.0.1
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN_ONCE([NC_CONFIG_SHADOW_DIR], [

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
			into the ]m4_quote(NC_CONFNEW_SUBDIR)[ directory without modifying
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
	])

	dnl  NC_THREATEN_FILES(file1[, file2[, file3[, ... fileN]]])
	dnl  **********************************************************************
	AC_DEFUN([NC_THREATEN_FILES], [
		AM_COND_IF([HAVE_EXTENDED_CONFIG], [
			AC_CONFIG_FILES(m4_foreach([_F_ITER_], m4_dquote(]m4_dquote(m4_map_args_sep([m4_normalize(], [)], [,], ][$][@][))[),
				[m4_ifnblank(m4_quote(_F_ITER_),
					[n4_case_in(m4_quote(_F_ITER_), m4_quote(NC_THREATENED_LIST),
						[n4_case_in(m4_quote(_F_ITER_), m4_quote(NC_SHADOW_REDEF), [],
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
	])

	dnl  NC_THREATEN_BLINDLY
	dnl  **********************************************************************
	AC_DEFUN_ONCE([NC_THREATEN_BLINDLY],
		[NC_THREATEN_FILES(m4_shift(m4_bpatsubst(m4_quote(m4_esyscmd([find ']m4_quote(NC_SHADOW_DIR)[' -type f -name '*.in' -printf ", [[%P{/@/}]]"])), [\.in{/@/}], [])))])

	dnl  NC_SHADOW_AFTER_OUTPUT[(if-merge-cmds[, if-sandbox-cmds])]
	dnl  **********************************************************************
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
			[m4_warn([syntax], [NC_CONFIG_SHADOW_DIR has been invoked but no files have been threatened.])])])

])



dnl  **************************************************************************
dnl  NOTE:  The `NC_` prefix (which stands for "Not autoConf") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

