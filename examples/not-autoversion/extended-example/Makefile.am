# Process this file with automake to produce Makefile.in


ACLOCAL_AMFLAGS = -I m4

SUBDIRS = \
	src

dist_doc_DATA = \
	AUTHORS \
	COPYING \
	ChangeLog \
	NEWS \
	README

EXTRA_DIST = \
	ChangeLog.md \
	INSTALL \
	NEWS \
	README.md \
	bootstrap \
	package.json \
	.editorconfig


# Remove `$(docdir)` directory on uninstall
uninstall-local:
	-rm -r '$(DESTDIR)$(docdir)';

distclean-local:
	-rm -rf '@confnewdir@';


if HAVE_UPDATES

.PHONY: mergenew
mergenew:
	-cp -rf $(confnewdir)/* ./

endif


# EOF

