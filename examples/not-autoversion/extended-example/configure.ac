dnl  Process this file with autoconf to produce a configure script.


m4_include([autostuff/m4/index.m4])

AC_PREREQ([2.69])

m4_include([HISTORY.m4])

AC_INIT([Foo Bar Library],
	NR_PROJECT_VERSION,
	[the.author@example.com],
	[libfoobar],
	[https://www.example.com])

AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_AUX_DIR([build-aux])

#  Add `--enable-extended-config[=MODE]` option
NC_CONFIG_SHADOW_DIR([autostuff/shadows])

AC_CONFIG_SRCDIR([src/foobar.c])

AC_CONFIG_HEADERS([config.h])

AC_CONFIG_FILES([Makefile src/Makefile])

# Export the computed version string to `package.json` when the `configure`
# script is invoked with `--enable-extended-config`...
NC_THREATEN_FILES([package.json])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC

NC_AUTOVERSION_SUBSTITUTIONS

LT_INIT

AC_OUTPUT

AC_MSG_NOTICE(m4_normalize([Current version is ]AC_PACKAGE_VERSION[ (binary
	version ]NR_BINARY_VERSION[ - libtool ]NR_LIBTOOL_VERSION_INFO[). The
	public header has changed ]NR_SOURCE_AGE[ times since the last
	interface change.]))

AC_MSG_NOTICE([Type ${0} --enable-extended-config to update the package.json file.])

dnl  EOF

