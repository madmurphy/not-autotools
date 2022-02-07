#!/bin/bash
#
# create_test_directory.sh
#

M4SUGAR_DIR='/usr/share/autoconf/m4sugar'

if [[ ! -d "${M4SUGAR_DIR}" ]]; then
	echo 'You don'\''t have GNU Autoconf installed. Abort.'
	exit 1
fi

mkdir -p ../tests
cd ../tests
rm -rf m4sugar
ln -s "${M4SUGAR_DIR}" m4sugar

cat << '_NA_HEREDOC_' > 'do_your_tests_here.m4'
dnl  **************************************************************************
dnl
dnl  Launch
dnl
dnl      m4 do_your_tests_here.m4
dnl
dnl  to parse this file.
dnl
dnl  **************************************************************************
include(m4sugar/m4sugar.m4)
m4_include([m4sugar/m4sh.m4])
m4_init
m4_define([AC_DEFUN], m4_defn([m4_defun]))
m4_define([AC_DEFUN_ONCE], m4_defn([m4_defun]))
m4_define([n4_sincludedir],
	[m4_pushdef([_files_], m4_dquote(m4_dquote(m4_shift(m4_esyscmd([find '$1' -type f -name '*.m4' -printf ", [[%p]]" 2>/dev/null])))))[]m4_ifnblank(m4_expand(_files_), [m4_foreach([_file_], _files_, [m4_include(_file_)])])[]m4_popdef([_files_])])[]n4_sincludedir([../m4/])[]m4_divert[]dnl
dnl
dnl  **************************************************************************
dnl  PLEASE WRITE YOUR M4 CODE AFTER THIS COMMENT
dnl  **************************************************************************
dnl
dnl  This is just an example...
n4_repeat([79], [~])
_NA_HEREDOC_

echo 'A directory for experimenting on the Not Autotools project has been created in'
echo "$(pwd)."
