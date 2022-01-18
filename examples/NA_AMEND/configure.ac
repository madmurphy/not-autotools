dnl  Process this file with autoconf to produce a configure script.

dnl  In this example package the `src/main.h` file is automatically generated.
dnl  The data type used for calculations will be either `int` (default) or
dnl  `long long int`, depending on whether the `configure` script has been
dnl  invoked with the `--enable-long-types` option or not. To generate the
dnl  `src/main.h` file, the model header `models/main.h` is amended using the
dnl  `NA_AMEND()` macro.


AC_PREREQ([2.69])

m4_include([autostuff/m4/not-autotools.m4])

AC_INIT([Foo Bar Library],
	[0.1.0],
	[the.author@example.com],
	[libfoobar],
	[https://www.example.com])

AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_AUX_DIR([build-aux])

AC_CONFIG_SRCDIR([src/main.c])

AC_CONFIG_HEADERS([config.h])

AC_CONFIG_FILES([Makefile src/Makefile])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC

###  Add `--enable-long-types` option
AC_ARG_ENABLE([long-types],
	[AS_HELP_STRING([--enable-long-types],
		[blablabla
		@<:@default=no@:>@])],
	[:],
	[AS_VAR_SET([enable_long_types], ['no'])])

AM_CONDITIONAL([WANT_LONG_TYPES], [test "x${enable_long_types}" = xyes])

##  src/Makefile.am, `make main.h` - standard
NC_SUBST_NOTMAKE([foobar_standard_recipe],
	m4_normalize([
		']NA_ESC_APOS(m4_quote(NA_TRIANGLE_BRACKETS_TO_MAKE_VARS(
		m4_quote(NA_DOUBLE_DOLLAR(m4_quote(NA_AMEND([<@>],
			[<top_srcdir>/models/main.h],
			[[CODE_HEADER],
				[<top_srcdir>/amendments/code-header.h]])))))))[;'
	]))

##  src/Makefile.am, `make main.h` - long long int
NC_SUBST_NOTMAKE([foobar_long_long_recipe],
	m4_normalize([
		']NA_ESC_APOS(m4_quote(NA_TRIANGLE_BRACKETS_TO_MAKE_VARS(
		m4_quote(NA_DOUBLE_DOLLAR(m4_quote(NA_AMEND([<@>],
			[<top_srcdir>/models/main.h],
			[[CODE_HEADER],
				[<top_srcdir>/amendments/code-header.h]],
			[[SUM_TEST_FUNCTION],
				[<top_srcdir>/amendments/long-long-sum-test.h]],
			[[MULTIPLY_TEST_FUNCTION],
				[<top_srcdir>/amendments/long-long-multiply-test.h]])))))))[
			;'
	]))

AM_COND_IF([WANT_LONG_TYPES],
	[AS_VAR_SET([preferred_data_type], ['long long int'])],
	[AS_VAR_SET([preferred_data_type], ['int'])])

AC_DEFINE_UNQUOTED([CALC_DATA_TYPE], [${preferred_data_type}],
	[Preferred data type.])

LT_INIT

AC_OUTPUT

dnl  EOF

