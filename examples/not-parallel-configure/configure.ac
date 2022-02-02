dnl  Process this file with autoconf to produce a configure script.


m4_include([autostuff/m4/not-parallel-configure.m4])

AC_PREREQ([2.69])

AC_INIT([Foo Bar Library],
	[0.1.0],
	[the.author@example.com],
	[libfoobar],
	[https://www.example.com])

AC_CONFIG_MACRO_DIR([m4])

AC_CONFIG_AUX_DIR([build-aux])

AC_CONFIG_SRCDIR([src/foobar.c])

AC_CONFIG_HEADERS([config.h])

AC_CONFIG_FILES([Makefile src/Makefile])

AM_INIT_AUTOMAKE([1.11])

AM_SILENT_RULES([yes])

AC_PROG_CC

# Start a new unnamed thread....
NC_THREAD_NEW([
	AC_MSG_NOTICE([Starting a parallel test...])
	# Do something expensive here
	sleep 3
	# ...
	AS_VAR_SET([TEST_RESULT_1], [foo])
	AC_MSG_NOTICE([Parallel test 1 has terminated])
])

# Start another thread, named this time....
NC_THREAD_NEW([my_named_thread], [
	# Do something expensive here
	# ...
	sleep 1
	# ...
	AS_VAR_SET([TEST_RESULT_2], [bar])
	AC_MSG_NOTICE([Parallel test 2 has terminated])
])

# This message will appear immediately, without waiting for the test
# to be completed
AC_MSG_NOTICE([Hello world])

# Do other unrelated things here
# ...

LT_INIT

# ...

AC_MSG_NOTICE([Wait until all the threads have returned...])

NC_JOIN_THREADS

AC_MSG_NOTICE([The result of the first test was ${TEST_RESULT_1}])

AC_MSG_NOTICE([The result of the second test was ${TEST_RESULT_2}])

AC_OUTPUT

dnl  EOF

