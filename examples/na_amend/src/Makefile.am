# Process this file with automake to produce Makefile.in

AM_CPPFLAGS = \
	"-DPACKAGE_LOCALE_DIR=\"$(localedir)\"" \
	"-DPACKAGE_SRC_DIR=\"$(srcdir)\"" \
	"-DPACKAGE_DATA_DIR=\"$(pkgdatadir)\"" \
	"-DG_LOG_DOMAIN=\"FooBar\""

AM_CFLAGS = \
	-Wall\
	-g \
	-pedantic \
	$(WARN_CFLAGS) \
	$(FOOBAR_CFLAGS)

lib_LTLIBRARIES = \
	libfoobar.la

libfoobar_la_SOURCES = \
	main.c

BUILT_SOURCES = \
	main.h

nodist_libfoobar_la_SOURCES = \
	$(BUILT_SOURCES)

libfoobar_la_LDFLAGS = \
	-version-info 0:0:0

libfoobar_la_LIBADD = \
	$(FOOBAR_LIBS)

CLEANFILES = \
	main.h


# Amend `main.h`
if WANT_LONG_TYPES

main.h: \
 $(top_srcdir)/amendments/code-header.h \
 $(top_srcdir)/amendments/long-long-multiply-test.h \
 $(top_srcdir)/amendments/long-long-sum-test.h
	@@foobar_long_long_recipe@

else !WANT_LONG_TYPES

main.h: \
 $(top_srcdir)/amendments/code-header.h
	@@foobar_standard_recipe@

endif !WANT_LONG_TYPES


# EOF

