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
dnl  C   C O M P I L E R   T E S T S
dnl  **************************************************************************


dnl  NC_CC_CHECK_SIZEOF(data-type[, headers[, store-as[, extra-sizes]]])
dnl  **************************************************************************
dnl
dnl  Checks for the size of `data-type` using **compile checks**, not run
dnl  checks.
dnl
dnl  This macro is based on the **Autoconf Archive**'s macro
dnl  `AX_COMPILE_CHECK_SIZEOF()`, to which some improvements have been added:
dnl
dnl  - An optional `store-as` argument has been implemented for storing the
dnl    size of *expressions* (which often contain characters forbidden as
dnl    variable names), such as
dnl    `NC_CC_CHECK_SIZEOF([sizeof(char)], [], [size_t])`, where
dnl    `sizeof(sizeof(char))` (previously impossible to store, since it does
dnl    not form a valid variable name) is now stored as `size_t` (i.e., a
dnl    preprocessor macro named `SIZEOF_SIZE_T` and a `configure` variable
dnl    named `${ac_cv_sizeof_size_t}` are created) -- remember that
dnl    `sizeof(sizeof(char))` is of type `size_t` by definition
dnl  - The `#include <sys/types.h>` line, previously automatically passed to
dnl    the compiler, has now been removed (the user can always provide it
dnl    manually, using the `headers` argument -- see below)
dnl  - Code readability has been improved
dnl
dnl  You can find the original Autoconf Archive macro at:
dnl  https://www.gnu.org/software/autoconf-archive/ax_compile_check_sizeof.html
dnl
dnl  As with the original macro, it is possible to supply `headers` to look
dnl  into, and the check will cycle through 1 2 4 8 16 and any `extra-sizes`
dnl  the user supplies. If a match is found, it will #define SIZEOF_`DATA-TYPE`
dnl  to that value. Otherwise it will emit a `configure` time error indicating
dnl  the size of the type could not be determined.
dnl
dnl  The trick is that C will not allow duplicate `case` labels. While this is
dnl  valid C code:
dnl
dnl      switch (0) case 0: case 1:;
dnl
dnl  The following is not:
dnl
dnl      switch (0) case 0: case 0:;
dnl
dnl  Thus, `AC_COMPILE_IFELSE()` will fail if the currently tried size does not
dnl  match.
dnl
dnl  Here is an example skeleton `configure.in` script, demonstrating the
dnl  macro's usage:
dnl
dnl      AC_PROG_CC
dnl      AC_CHECK_HEADERS(stddef.h unistd.h)
dnl      AC_TYPE_SIZE_T
dnl      AC_CHECK_TYPE(ssize_t, int)
dnl
dnl      headers='#include <sys/types.h>
dnl      #ifdef HAVE_STDDEF_H
dnl      #include <stddef.h>
dnl      #endif
dnl      #ifdef HAVE_UNISTD_H
dnl      #include <unistd.h>
dnl      #endif
dnl      '
dnl
dnl      NC_CC_CHECK_SIZEOF(char)
dnl      NC_CC_CHECK_SIZEOF(short)
dnl      NC_CC_CHECK_SIZEOF(int)
dnl      NC_CC_CHECK_SIZEOF(long)
dnl      NC_CC_CHECK_SIZEOF(unsigned char *)
dnl      NC_CC_CHECK_SIZEOF(void *)
dnl      NC_CC_CHECK_SIZEOF(size_t, ${headers})
dnl      NC_CC_CHECK_SIZEOF(ssize_t, ${headers})
dnl      NC_CC_CHECK_SIZEOF(ptrdiff_t, ${headers})
dnl      NC_CC_CHECK_SIZEOF(off_t, ${headers})
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: `NA_SANITIZE_VARNAME()` from `not-autotools.m4`
dnl  Version: 1.0.0
dnl  Authors: (c) 2008 Kaveh Ghazi <ghazi@caip.rutgers.edu>, (c) 2017 Reini
dnl    Urban <rurban@cpan.org>, (c) 2020 madmurphy <madmurphy333@gmail.com>
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CC_CHECK_SIZEOF], [
	m4_pushdef([__label__],
		NA_SANITIZE_VARNAME([sizeof_]m4_tolower(m4_ifblank([$3],
			[[$1]], [[$3]]))))
	AC_MSG_CHECKING([size of `$1`])
	AC_CACHE_VAL([ac_cv_]__label__, [
		# List sizes in rough order of prevalence.
		for nc_sizeof in 4 8 1 2 16 m4_normalize([$4]) ; do
			AC_COMPILE_IFELSE([
				AC_LANG_PROGRAM([[$2]], [[
					switch (0) {
						case 0:
						case (sizeof ($1) ==
							${nc_sizeof}):;
					}
				]])
			],
				[AS_VAR_COPY([ac_cv_]__label__, [nc_sizeof])])
			AS_IF([test "x${ac_cv_]__label__[}" != x], [break;])
		done
	])
	AS_IF([test "x${ac_cv_]__label__[}" = x], [
		AC_MSG_RESULT([unknown])
		AC_MSG_ERROR([cannot determine a size for $1])
	])
	AC_MSG_RESULT([${ac_cv_]__label__[}])
	AC_DEFINE_UNQUOTED(m4_toupper(m4_quote(__label__)),
		[${ac_cv_]__label__[}],
		[The number of bytes in type $1])
	m4_ifnblank([$3],
		[AS_VAR_COPY([na_]m4_quote(m4_tolower([$3])), [nc_sizeof])])
	m4_popdef([__label__])
])


dnl  NC_CC_CHECK_CHAR_BIT()
dnl  **************************************************************************
dnl
dnl  Calculates the size in bits of the `char` data type using compile checks
dnl
dnl  The C Standard guarantees that a `char` data type is able to store at
dnl  least 8 bits, but does not guarantee that a `char` is exactly 8 bits,
dnl  although this is the case in most architectures.
dnl
dnl  Fortunately the `limits.h` header provides a `CHAR_BIT` macro containing
dnl  that exact information about the size of a `char` in bits. But what if we
dnl  are cross-compiling and cannot run a test on the target architecture?
dnl
dnl  This macro checks for the result of `CHAR_BIT` **using compile checks**,
dnl  not run checks. It is inspired by the **Autoconf Archive**'s macro
dnl  `AX_COMPILE_CHECK_SIZEOF()`, that takes advantage of the fact that the C
dnl  compiler does not allow duplicate `case` labels, and exploits the fact
dnl  that in C a computation involving unsigned operands can never overﬂow.
dnl
dnl  As for the C99 standard, § 6.2.5.9:
dnl
dnl     A computation involving unsigned operands can never overﬂow, because a
dnl     result that cannot be represented by the resulting unsigned integer
dnl     type is reduced modulo the number that is one greater than the largest
dnl     value that can be represented by the resulting type.
dnl
dnl  Thus, by gradually increasing a value assigned to an `unsigned char`, this
dnl  macro reaches the point where an `overﬂow` would occur. But since this
dnl  cannot happen, the value is reduced modulo the number that is one greater
dnl  than the largest value that can be represented by the resulting type. That
dnl  reduced number, though, has been already used for a `case` label (it is
dnl  always zero indeed), so at that point the program will fail to compile.
dnl
dnl  The computed value will be accessible in the `configure` script through
dnl  the `ac_cv_char_bit` shell variable, while in the C code it will be
dnl  possible to access it using the `COMPUTED_CHAR_BIT` preprocessor macro.
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CC_CHECK_CHAR_BIT], [
	AC_MSG_CHECKING([size of `char` in bits])
	AC_CACHE_VAL([ac_cv_char_bit], [
		# Minimum size in bits for `char` is guaranteed to be 8
		for nc_char_bit in {8..64}; do
			AC_COMPILE_IFELSE([
				AC_LANG_PROGRAM(, [[
					switch (0) {
						case 0: case ((unsigned char)
						(1 << ${nc_char_bit})):;
					}
				]])
			], [], [break])
		done
		AS_VAR_COPY([ac_cv_char_bit], [nc_char_bit])
	])
	AC_MSG_RESULT([${ac_cv_char_bit}])
	AC_DEFINE_UNQUOTED([COMPUTED_CHAR_BIT],
		[${ac_cv_char_bit}],
		[The number of bits in `char`])
])


dnl  NC_CC_CHECK_POSIX([posix-version])
dnl  **************************************************************************
dnl
dnl  Checks whether the POSIX C API is available
dnl
dnl  Example #1 (any POSIX version):
dnl
dnl      NC_CC_CHECK_POSIX
dnl
dnl      AS_IF([test "x${ac_cv_have_posix_c}" = xyes],
dnl          [AC_MSG_NOTICE([The POSIX C Standard is supported])],
dnl          [AC_MSG_NOTICE([The POSIX C Standard is not supported])])
dnl
dnl  Example #2 (POSIX 2008):
dnl
dnl      NC_CC_CHECK_POSIX([200809L])
dnl
dnl      AS_IF([test "x${ac_cv_have_posix_200809L_c}" = xyes],
dnl          [AC_MSG_NOTICE([The POSIX C Standard version 2008 is supported])],
dnl          [AC_MSG_NOTICE([The POSIX C Standard version 2008 is not supported])])
dnl
dnl  If a `posix-version` argument is passed, this macro will look specifically
dnl  for the version queried. Possible values for `posix-version` are the same
dnl  values supported by the POSIX standard `_POSIX_C_SOURCE` feature test
dnl  macro.
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Authors: madmurphy, Vilhelm Gray
dnl    (https://stackoverflow.com/a/18240603/2732907)
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CC_CHECK_POSIX], [
	AC_MSG_CHECKING([whether we have POSIX]m4_ifnblank([$1],
		[[ @{:@$1@:}@]]))
	AC_CACHE_VAL([ac_cv_have_posix]m4_ifnblank([$1], [[_$1]])[_c], [
		AC_EGREP_CPP([posix_supported], [
			@%:@define _POSIX_C_SOURCE ]m4_ifnblank([$1],
				[[$1]], [[200809L]])[
			@%:@include <unistd.h>
			@%:@ifdef _POSIX_VERSION
			]m4_ifnblank([$1],
				[[@%:@if _POSIX_VERSION == $1]])[
			posix_supported
			]m4_ifnblank([$1], [@%:@endif])[
			@%:@endif
		], [
			AS_VAR_SET([ac_cv_have_posix]m4_ifnblank([$1], [[_$1]])[_c],
				['yes'])
		], [
			AS_VAR_SET([ac_cv_have_posix]m4_ifnblank([$1], [[_$1]])[_c],
				['no'])
		])
	])
	AC_MSG_RESULT([${ac_cv_have_posix]m4_ifnblank([$1], [[_$1]])[_c}])
])


dnl  NC_CPP_IF(expr, if-yes[, if-no[, CFLAGS [, header1[, ... headerN]]]])
dnl  **************************************************************************
dnl
dnl  Run `#if (expr)`, with optional compiler flags and headers
dnl
dnl  For example, if you are writing an extension for Nautilus and you want to
dnl  to know if the copy installed in the user's machine uses the version 3 of
dnl  the GTK libraries, you can run:
dnl
dnl      NC_CPP_IF([GTK_MAJOR_VERSION == 3],
dnl          [AC_MSG_NOTICE([The version of Nautilus installed uses GTK 3])],
dnl          [AC_MSG_NOTICE([The version of Nautilus installed does not use GTK 3])],
dnl          ["$(pkg-config --cflags libnautilus-extension)"],
dnl          [nautilus-extension.h])
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CPP_IF], [
	AS_VAR_COPY([_na_oldcflags_], [CFLAGS])
	AS_VAR_SET([CFLAGS], [$4])
	AC_MSG_CHECKING([if `$1`])
	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
		]m4_foreach([__ITER__], m4_quote(m4_shiftn(4, $@)),
			[@%:@include <__ITER__>m4_newline()])[
		@%:@if ($1)
		@%:@error "Expression $1 matches"
		@%:@endif
	]],)], [
		AC_MSG_RESULT([no])
		AS_VAR_COPY([CFLAGS], [_na_oldcflags_])
		AS_UNSET([_na_oldcflags_])
		$3
	], [
		AC_MSG_RESULT([yes])
		AS_VAR_COPY([CFLAGS], [_na_oldcflags_])
		AS_UNSET([_na_oldcflags_])
		$2
	])
])


dnl  NC_CC_STATIC_ASSERT(expr, if-yes[, if-no[, CFLAGS [, header1[, ... headerN]]]])
dnl  **************************************************************************
dnl
dnl  Run `_Static_assert(expr)`, with optional compiler flags and headers
dnl
dnl  For example, if you are writing an extension for Nautilus and you want to
dnl  to know if the copy installed in the user's machine uses the version 3 of
dnl  the GTK libraries, you can run:
dnl
dnl      NC_CC_STATIC_ASSERT([GTK_MAJOR_VERSION == 3],
dnl          [AC_MSG_NOTICE([The version of Nautilus installed uses GTK 3])],
dnl          [AC_MSG_NOTICE([The version of Nautilus installed does not use GTK 3])],
dnl          ["$(pkg-config --cflags libnautilus-extension)"],
dnl          [nautilus-extension.h])
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CC_STATIC_ASSERT], [
	AS_VAR_COPY([_na_oldcflags_], [CFLAGS])
	AS_VAR_SET([CFLAGS], [$4])
	AC_MSG_CHECKING([if `$1`])
	AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
		]m4_foreach([__ITER__], m4_quote(m4_shiftn(4, $@)),
			[@%:@include <__ITER__>m4_newline()])[
	]], [[
		_Static_assert($1);
	]])], [
		AC_MSG_RESULT([yes])
		AS_VAR_COPY([CFLAGS], [_na_oldcflags_])
		AS_UNSET([_na_oldcflags_])
		$2
	], [
		AC_MSG_RESULT([no])
		AS_VAR_COPY([CFLAGS], [_na_oldcflags_])
		AS_UNSET([_na_oldcflags_])
		$3
	])
])


dnl  NC_CC_CHECK_UINT_FROM_TO(name, min[, max[, CFLAGS [, header1[, ... headerN]]]])
dnl  **************************************************************************
dnl
dnl  Calculates the value of an unsigned integer using compile checks, with
dnl  optional compiler flags and headers
dnl
dnl  This macro can be very expensive, since it will run a test for each
dnl  number in the range specified. Therefore it is generally used for limited
dnl  computations, such as determining a small version number.
dnl
dnl  The computed value will be accessible in the `configure` script using the
dnl  `[ac_cv_]lc(name)` shell variable, where `lc(name)` is the `name` argument
dnl  **in lower case**.
dnl
dnl  For example,
dnl
dnl      NC_CC_CHECK_UINT_FROM_TO([GTK_MAJOR_VERSION],
dnl          [0],
dnl          [],
dnl          ["$(pkg-config --cflags libnautilus-extension)"],
dnl          [nautilus-extension.h])
dnl
dnl      AC_MSG_NOTICE([The version of Nautilus installed uses GTK ${ac_cv_gtk_major_version}])
dnl
dnl  will set a `ac_cv_gtk_major_version` shell variable, containing the major
dnl  version of the GTK libraries used by the copy of Nautilus currently
dnl  installed -- useful if you are writing an extension for Nautilus.
dnl
dnl  If the `name` is not an integer, or if the value of `name` is outside the
dnl  range specified, the computed value will be set to `-1`. 
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CC_CHECK_UINT_FROM_TO], [
	AS_VAR_COPY([_na_oldcflags_], [CFLAGS])
	AS_VAR_SET([CFLAGS], [$4])
	m4_pushdef([_na_tmp_headers_],
		m4_foreach([__ITER__], m4_quote(m4_shiftn(4, $@)),
			[[@%:@include <]__ITER__[>m4_newline()]]))
	m4_pushdef([_na_tmp_uint_varname_], [ac_cv_]m4_tolower([$1]))
	AC_MSG_CHECKING([value of `$1`])
	AC_CACHE_VAL(m4_quote(_na_tmp_uint_varname_), [
		AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[
			]m4_quote(_na_tmp_headers_)[
			@%:@include <assert.h>
		]], [[
			_Static_assert($2 <= $1);
			]m4_ifnblank([$3], [[_Static_assert($3 >= $1);]])[
		]])],
			[
				m4_ifblank([$3],
					[nc_char_bit=$2; while :; do],
					[for nc_char_bit in {$2..$3}; do])
					AC_COMPILE_IFELSE([
						AC_LANG_PROGRAM([m4_quote(_na_tmp_headers_)], [[
							switch (0) {
								case 0: case $1 - ${nc_char_bit}:;
							}
						]])
					],
					[m4_ifblank([$3],
						[nc_char_bit=$((nc_char_bit + 1))])],
					[break])
				done
				AS_VAR_COPY(m4_quote(_na_tmp_uint_varname_), [nc_char_bit])
				AS_UNSET([nc_char_bit])
			],
			[AS_VAR_SET(m4_quote(_na_tmp_uint_varname_), [-1])])
	])
	AC_MSG_RESULT([${]m4_quote(_na_tmp_uint_varname_)[}])
	m4_popdef([_na_tmp_uint_varname_])
	m4_popdef([_na_tmp_headers_])
	AS_VAR_COPY([CFLAGS], [_na_oldcflags_])
	AS_UNSET([_na_oldcflags_])
])


dnl  NC_CPP_EXPAND(store-result, preprocessor-expression, [CPPFLAGS],
dnl                header1[, header2[, header3[, ... headerN]]])
dnl  **************************************************************************
dnl
dnl  Expand the value assigned to a preprocessor macro
dnl
dnl  The expanded value will be accessible in the `configure` script using the
dnl  `[ac_cv_]lc(store-result)` shell variable, where `lc(store-result)` is the
dnl  `store-result` argument **in lower case**.
dnl
dnl  For example, if you are writing an extension for Nautilus and you want to
dnl  to know the value assigned to the `GTK_MAJOR_VERSION` preprocessor macro,
dnl  you can run:
dnl
dnl      NC_CPP_EXPAND([gtk_maj_ver],
dnl          [GTK_MAJOR_VERSION],
dnl          ["$(pkg-config --cflags libnautilus-extension)"],
dnl          [nautilus-extension.h])
dnl
dnl      AC_MSG_NOTICE([The version of Nautilus installed uses GTK ${ac_cv_gtk_maj_ver}])
dnl
dnl  This macro may be invoked only after having invoked `AC_INIT()`.
dnl
dnl  Expansion type: shell code
dnl  Requires: nothing
dnl  Version: 1.0.0
dnl  Author: madmurphy
dnl
dnl  **************************************************************************
AC_DEFUN([NC_CPP_EXPAND], [
	AC_LANG_PREPROC_REQUIRE()
	AC_REQUIRE([AC_PROG_SED])
	m4_pushdef([_na_tmp_varname_], [ac_cv_]m4_tolower([$1]))
	AS_VAR_COPY([_na_oldcppflags_], [CPPFLAGS])
	AS_VAR_SET([CPPFLAGS], [$3])
	AC_MSG_CHECKING([for the `$2` preprocessor macro])
	AC_CACHE_VAL(_na_tmp_varname_, [
		AC_LANG_CONFTEST([AC_LANG_SOURCE([[
			]m4_foreach([__iter__], m4_quote(m4_shift3($@)),
				[[@%:@include <]__iter__[>]m4_newline()])[
			@@HMCE64EGP2ZTI0G2HHR47@@$2@@CYJ7RQ8O1XK990R21LYM5@@
		]])])
		AS_VAR_SET(_na_tmp_varname_,
			["$((eval "${ac_cpp} conftest.${ac_ext}") 2>&AS_MESSAGE_LOG_FD | \
			${SED} -z 's/^.*@@HMCE64EGP2ZTI0G2HHR47@@\(.*\)@@CYJ7RQ8O1XK990R21LYM5@@.*$/\1/')"])
	])
	AC_MSG_RESULT([done])
	AS_VAR_COPY([CPPFLAGS], [_na_oldcppflags_])
	AS_UNSET([_na_oldcppflags_])
	rm -rf conftest*
	m4_popdef([_na_tmp_varname_])
])



dnl  **************************************************************************
dnl  NOTE:  The `NC_` prefix (which stands for "Not autoConf") is used with the
dnl         purpose of avoiding collisions with the default Autotools prefixes
dnl         `AC_`, `AM_`, `AS_`, `AX_`, `LT_`.
dnl  **************************************************************************



dnl  EOF

