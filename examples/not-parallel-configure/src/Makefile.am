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
	foobar.h \
	foobar.c

libfoobar_la_LDFLAGS = \
	-version-info $(LIBTOOL_VERSION_INFO)

libfoobar_la_LIBADD = \
	$(FOOBAR_LIBS)

# EOF

