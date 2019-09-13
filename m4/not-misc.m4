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
dnl                                                -- Released under GNU GPL3 --
dnl
dnl                                   https://github.com/madmurphy/not-autotools
dnl  ***************************************************************************



dnl  ***************************************************************************
dnl  M I S C E L L A N E A
dnl  ***************************************************************************



dnl  NM_SET_VERSION_ENVIRONMENT(pkgname, majver, minver, revver)
dnl  ***************************************************************************
dnl
dnl  Checks whether this package must cohabitate with other versions of itself
dnl
dnl  The macro checks whether a `$MULTIVERSION_PACKAGE` environment variable is
dnl  present during the `automake` process and sets the versioning macros
dnl  accordingly.
dnl
dnl  This macro can be invoked only once. Note that `automake` runs at a
dnl  different time (and often even on a different computer) than the
dnl  `configure` script.
dnl
dnl  After being invoked the following argumentless macros will be created:
dnl
dnl  - `NA_IS_MULTIVERSION`: expands to `1` if the `$MULTIVERSION_PACKAGE`
dnl    environment variable was set to any value other than `no` during the
dnl    the automake process, expands to `0` otherwise
dnl  - `NA_PROJECT_NAME`: expands to the argument `pkgname` passed to this macro
dnl  - `NA_PROJECT_MAJVER`: expands to the argument `majver` passed to this
dnl    macro
dnl  - `NA_PROJECT_MINVER`: expands to the argument `minver` passed to this
dnl    macro
dnl  - `NA_PROJECT_REVVER`: expands to the argument `revver` passed to this
dnl    macro
dnl  - `NA_PROJECT_DISTNAME` expands to `pkgname[]majver` when
dnl    `NA_IS_MULTIVERSION` expands to [yes], it expands to `pkgname` otherwise
dnl
dnl  `NM_SET_VERSION_ENVIRONMENT()` is usually invoked right before `AC_INIT()`.
dnl
dnl  For instance, in
dnl
dnl      NA_GET_VERSION_ENVIRONMENT([gphoto], [2], [5], [23])
dnl      AC_PREREQ([2.69])
dnl      AC_INIT([lib]NA_PROJECT_DISTNAME, NA_PROJECT_MAJVER[.]NA_PROJECT_MINVER[.]NA_PROJECT_REVVER)
dnl
dnl  `AC_PACKAGE_NAME` will expand to `libgphoto2` if a `$MULTIVERSION_PACKAGE`
dnl  environment variable was set to any value other than `no` during the
dnl  automake process, it will expand to `libgphoto` otherwise. The package
dnl  maintainer can thus provide an environment variable to the `automake`
dnl  program to store information hard-coded inside the `configure` script:
dnl
dnl      MULTIVERSION_PACKAGE=yes automake --add-missing
dnl
dnl  Expansion type: literal (void)
dnl  Requires: nothing
dnl
dnl  ***************************************************************************
AC_DEFUN_ONCE([NM_SET_VERSION_ENVIRONMENT], [
	m4_define([NA_PROJECT_NAME], [$1])
	m4_define([NA_PROJECT_MAJVER], [$2])
	m4_define([NA_PROJECT_MINVER], [$3])
	m4_define([NA_PROJECT_REVVER], [$4])
	m4_define([NA_IS_MULTIVERSION], m4_esyscmd_s([test "x${MULTIVERSION_PACKAGE}" = x -o "x${MULTIVERSION_PACKAGE}" = xno && echo '0' || echo '1']))
	m4_define([NA_PROJECT_DISTNAME], m4_if(NA_IS_MULTIVERSION, [1], NA_PROJECT_NAME[]NA_PROJECT_MAJVER, NA_PROJECT_NAME))
])



dnl  ***************************************************************************
dnl  Note:  The `NM_` prefix (which stands for "Not autoMake") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  ***************************************************************************


dnl  EOF

